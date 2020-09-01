//
//  Chart.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CareKit

struct YPDChartError: Error {
    var description: String
    init(_ description: String){
        self.description = description
    }
}

/// Class for handling the generation of data points needed to chart metric log data with an OCKChartView
class YPDChartData: ObservableObject {
    
    // These two property wrappers add in a default implementation of `objectWillChange`, which will notify all subscribers dependant on the properties that they are about to change, and as such should re-render / update their views.
    @Published var dataSeries: [OCKDataSeries] = []
    @Published var horizontalAxisChartMarkers: [String] = []
    @Published var error = ""
    
    var timeUnit: AggregationCriteria?
    var attributes: [YPDCheckinType]
    var jsonData: JSON?
    var data: [[(Date, Double)]]?
    
    /// Returns the minimum and maximum y values across all of the OCKDataSeries' which are contained within the YPDChartData object.
    var minMaxYValues: (CGFloat, CGFloat) {
        
        let minMaxForEachSeries = self.dataSeries.map(self.getMinMaxYValues(forDataSeries:))
        
        let minY = minMaxForEachSeries.map {$0.0}.sorted { $0 < $1 }.first ?? 0
        let maxY = minMaxForEachSeries.map {$0.1}.sorted{ $0 < $1 }.first ?? 0
        
        // Add some fudge.
        return (CGFloat(Int(minY*0.99)), CGFloat(Int((maxY*1.01 + 0.5))))
        
    }
    
    
    /// Convenience initialiser which fetches the aggregated health and checkin data JSON file from the backend, and initialises the ChartData object.
    /// - Parameters:
    ///     - attributes: The attributes (such as generalFeeling, Mood, etc) which correspond to the aggregated data
    ///     - timeUnit: The aggregation criteria (e.g. Day, Month, Week, etc)
    public init(attributes: [YPDCheckinType], selectedTimeUnit timeUnit: AggregationCriteria) {
        self.attributes = attributes
        self.timeUnit = timeUnit
        self.fetchDataAndInitialize(attributes: attributes, selectedTimeUnit: timeUnit)
    }
    
    /// - Parameters:
    ///     - data: The JSON data recieved from the Fetcher() class, containing the aggregated health and checkin data
    ///     - attributes: The attributes (such as generalFeeling, Mood, etc) which correspond to the aggregated data
    ///     - timeUnit: The aggregation criteria (e.g. Day, Month, Week, etc)
    public init(data: JSON, attributes: [YPDCheckinType], selectedTimeUnit timeUnit: AggregationCriteria) {
        self.attributes = attributes
        self.timeUnit = timeUnit
        self.jsonData = data
        self.initialize(data: data, attributes: attributes, selectedTimeUnit: timeUnit)
    }
    
    /// - Parameters:
    ///     - data: The tuple of (Date, Double) tuple pairs providing the data to be displayed in the chart.
    ///     - attributes: The attributes (such as generalFeeling, Mood, etc) which correspond to the aggregated data
    ///     - timeUnit: (Optional) The aggregation criteria (e.g. Day, Month, Week, etc)
    public init(multipleSeries: [[(Date, Double)]], attributes: [YPDCheckinType], selectedTimeUnit timeUnit: AggregationCriteria? = nil) {
        self.attributes = attributes
        self.timeUnit = timeUnit
        try? self.initialize(multipleSeries: multipleSeries, attributes: attributes)
    }
    
    /// Convenience method which fetches data given certain attributes and a time unit, and updates the chart data accordingly.
    /// - Parameters:
    ///     - attributes: The attributes (such as generalFeeling, Mood, etc) which correspond to the aggregated data
    ///     - timeUnit: The aggregation criteria (e.g. Day, Month, Week, etc)
    private func fetchDataAndInitialize(attributes: [YPDCheckinType], selectedTimeUnit timeUnit: AggregationCriteria){
        self.log("Fetching Chart Data")
        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: timeUnit) { (json) in
            DispatchQueue.main.async {
                if !json["success"].boolValue {
                    self.log("Error retrieving aggregated healthAndCheckinData:", json.stringValue)
                    self.error = json.stringValue
                }
                self.log("Received Chart Data.")
                self.initialize(data: json["result"], attributes: attributes, selectedTimeUnit: timeUnit)
            }
        }
    }
    
    /// Convenience method which can be used to initialize the object within the asynchronous call to fetch the health data .
    private func initialize(data: JSON, attributes: [YPDCheckinType], selectedTimeUnit timeUnit: AggregationCriteria){
        
        self.jsonData = data
        self.attributes = attributes
        self.timeUnit = timeUnit
        
        self.dataSeries = []
        self.data = []
        
        var sampleDates: [Date] = []
        
        // For each attribute, generate the data series chart points, as well as axis labels.
        attributes.forEach {
            let (dates, chartPoints) = self.generateChartPointsAndAxisLabelDates(forAttribute: $0.rawValue, andSelectedTimeUnit: timeUnit, ofAggregatedDataObjects: data.arrayValue, normalise: attributes.count > 1)
            
            sampleDates.append(contentsOf: dates)
            self.dataSeries.append(OCKDataSeries(dataPoints: chartPoints, title: $0.humanReadable, size: 3, color: Colour.chartColours.randomElement()!))
            
            // Append the data and dates to te data array.
            let dataToAppend = zip(dates, chartPoints.map { Double($0.y) }).map { $0 }

            self.data?.append(dataToAppend)
            
        }
        
        // Generate the horizontal axis labels for the chart.
        self.horizontalAxisChartMarkers = self.generateHorizontalAxisLabels(forCollectionDates: sampleDates)
        
//        print("Chart Data | Initialized chart data with attributes: \(attributes) and dataSeries \(self.dataSeries), data: \(self.data)")
        
    }
    
    /// Convenience method which can be used to initialize the YPDChartData object using the array of (Double, Date) tuples.
    private func initialize(multipleSeries: [[(Date, Double)]], attributes: [YPDCheckinType]) throws {
        
        guard multipleSeries.count == attributes.count else { throw YPDChartError("Length of data (\(multipleSeries)) does not match length of attributes (\(attributes)).") }
        
//        self.data = data
        self.attributes = attributes
        
        self.dataSeries = []
                
        var sampleDates: [Date] = []
        
        self.data = multipleSeries
        
        // For each attribute, generate the data series chart points, as well as axis labels.
        for i in 0..<multipleSeries.count {
            let series = multipleSeries[i]
            let attribute = attributes[i]
            
            let (dates, chartPoints) = self.generateChartPointsAndAxisLabelDates(forData: series, normalise: attributes.count > 1)
            
            sampleDates.append(contentsOf: dates)
            
            self.dataSeries.append(OCKDataSeries(dataPoints: chartPoints, title: attribute.humanReadable, size: 3, color: Colour.chartColours.randomElement()!))
        }
        
        
        // Generate the horizontal axis labels for the chart.
        self.horizontalAxisChartMarkers = self.generateHorizontalAxisLabels(forCollectionDates: sampleDates)
        
    }
    
    /// Updates the ChartData object given new attributes or selected time units.
    public func fetchNewData(forAttributes attributes: [YPDCheckinType]? = nil, selectedTimeUnit timeUnit: AggregationCriteria? = nil){
        print("Chart | Fetching chart data for attributes: \((attributes ?? []).map { $0.humanReadable }.joined(separator: ", ")) ")
        self.fetchDataAndInitialize(attributes: attributes ?? self.attributes, selectedTimeUnit: timeUnit ?? self.timeUnit ?? .day)
    }
    
    /// Given an array of Dates corresponding to date samples when metric logs were taken, cleans out duplicates and generates horizontal axis labels.
    private func generateHorizontalAxisLabels(forCollectionDates dates: [Date]) -> [String] {
        return Array(Set(dates)).sorted(by: { (firstDate, secondDate) -> Bool in
            return firstDate.timeIntervalSince1970 < secondDate.timeIntervalSince1970
        }).map { $0.axisLabelString }
    }
    
    /// Generates a series of chart points for a given attribute and array of aggregated health data & checkin objects.
    /// Parameters:
    /// - filterOutZeros: Filters out points which have a '0' value for the y axis. Useful for healthDataObjects where a '0' indicates the lack of a response.
    /// Returns:
    /// - Tuple ([String], [CGPoint]) denoting the horizontal axis labels as well as the individual data points.
    private func generateChartPointsAndAxisLabelStrings(forAttribute attribute: String, andSelectedTimeUnit timeUnit: AggregationCriteria, ofAggregatedDataObjects data: [JSON], filterOutZeros: Bool = true, normalise: Bool = false) -> ([String], [CGPoint]) {
       
        let (dates, points) = self.generateChartPointsAndAxisLabelDates(forAttribute: attribute, andSelectedTimeUnit: timeUnit, ofAggregatedDataObjects: data, filterOutZeros: filterOutZeros, normalise: normalise)
        
        return (dates.map { $0.axisLabelString }, points)
    }
    
    /// Generates the chart points to be used for the OCKDataSeries, as well as an array of Dates which can be concatenated amongst all attributes in order to generate all required horizontal axis labels.
    private func generateChartPointsAndAxisLabelDates(forAttribute attribute: String, andSelectedTimeUnit timeUnit: AggregationCriteria, ofAggregatedDataObjects data: [JSON], filterOutZeros: Bool = true, normalise: Bool = false, showDataSubset: Bool = true) -> ([Date], [CGPoint]) {
        
        // If normalise is set to true, then we will use the largest Y Value to normalise all the chart points within
        // the range [0, 1]
        var largestYValue: Double = 1
       
        let chartPoints = data.compactMap { (item) -> (Date, CGPoint)? in
            let stringToDateFormatter = ISO8601DateFormatter()
            stringToDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Parse the date value from the JSON string.
            
            guard let attributeValue = Double(item[attribute].stringValue),
                let parsedDate = stringToDateFormatter.date(from: item["startOfDate"].stringValue)
            else { return nil }
            
            // Ignore everything but the 'day', 'month' and 'year', as we would want to ensure that we do not produce multiple horizontal axis labels for dates of different times of the same day.
            let truncatedDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: parsedDate)
            
            // Set the largestYValue for normalisation.
            largestYValue = max(largestYValue, attributeValue)
            
            if let truncatedDate = Calendar.current.date(from: truncatedDateComponents) {
                return (truncatedDate, CGPoint(x: truncatedDate.timeIntervalSince1970, y: attributeValue))
            } else { return nil }
            
        }.filter { !filterOutZeros || $0.1.y != 0 }
            // Ensure that we constrain the number of points returned so that we do not overwhelm the user initially, and instead present a subset of the available datapoints.
            .suffix(showDataSubset ? timeUnit.maxNumberOfPoints : data.count)
        
        return (chartPoints.map { $0.0 }, chartPoints.map { CGPoint(x: $0.1.x, y: $0.1.y / CGFloat(normalise ? largestYValue : 1)) })
    }
    
    /// Generates the chart points to be used for the OCKDataSeries, as well as an array of Dates which can be concatenated amongst all attributes in order to generate all required horizontal axis labels. Convenience method which takes in array of (Date, Double) tuples instead of a JSON array
    private func generateChartPointsAndAxisLabelDates(forData data: [(Date, Double)], filterOutZeros: Bool = true, normalise: Bool = false, showDataSubset: Bool = true) -> ([Date], [CGPoint]) {
        
        // If normalise is set to true, then we will use the largest Y Value to normalise all the chart points within
        // the range [0, 1]
        var largestYValue: Double = 1
       
        let chartPoints = data.compactMap { (date, doubleValue) -> (Date, CGPoint)? in
            let stringToDateFormatter = ISO8601DateFormatter()
            stringToDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            // Parse the date value from the JSON string.
            
//            guard let doubleValue = Double(item[attribute].stringValue),
//                let date = stringToDateFormatter.date(from: item["startOfDate"].stringValue)
//            else { return nil }
                        
            // Ignore everything but the 'day', 'month' and 'year', as we would want to ensure that we do not produce multiple horizontal axis labels for dates of different times of the same day.
            let truncatedDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
            
            // Set the largestYValue for normalisation.
            largestYValue = max(largestYValue, doubleValue)
            
            if let truncatedDate = Calendar.current.date(from: truncatedDateComponents) {
                return (truncatedDate, CGPoint(x: truncatedDate.timeIntervalSince1970, y: doubleValue))
            } else { return nil }
            
        }.filter { !filterOutZeros || $0.1.y != 0 }
            // Ensure that we constrain the number of points returned so that we do not overwhelm the user initially, and instead present a subset of the available datapoints.
            .suffix(showDataSubset ? (self.timeUnit ?? .day).maxNumberOfPoints : data.count)
        
        return (chartPoints.map { $0.0 }, chartPoints.map { CGPoint(x: $0.1.x, y: $0.1.y / CGFloat(normalise ? largestYValue : 1)) })
    }

    /// Fetches the min and max y values for a given dimension passed on a dataseries.
    private func getMinMaxYValues(forDataSeries dataSeries: OCKDataSeries) -> (CGFloat, CGFloat) {
        
        let sorted = dataSeries.dataPoints.sorted { (firstPoint, secondPoint) -> Bool in
            return firstPoint.y < secondPoint.y
        }
        
        guard !sorted.isEmpty else {
            return (0, 0)
        }
        
        return (sorted.first!.y, sorted.last!.y)
        
    }
    
    private func log(_ msg: String...){
        print("Chart Util |", msg)
    }
    
}


extension Date {
    
    /// Formatter to convert from the Date object to the string which will be represented on the axis labels. We will use a format of 'day/month', which should suffice for most of the different time units.
    var dateToStringFormatter: DateFormatter {
        let dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "dd/MM"
        return dateToStringFormatter
    }
    
    var axisLabelString: String {
        return dateToStringFormatter.string(from: self)
    }
    
}
