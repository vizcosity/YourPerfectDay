//
//  YPDInsightsViewController.swift
//  Benson
//
//  Created by Aaron Baw on 05/04/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import CareKit
//import SwiftCharts
import SwiftyJSON

/// Determines the values which should be displayed by the UIPickerView.
//enum SelectionMode {
//    case ChartMetric
//    case TimeUnit
//}

// Questions:
// - How to add pull to refresh with an action
// - How to add spacing between cells

class YPDInsightViewController: UIViewController{
       

    @IBOutlet weak var chartViewContainer: UIView!

    @IBOutlet weak var chartActivityIndicator: UIActivityIndicatorView! {
        didSet {
            self.chartActivityIndicator.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chartMetricSelectionButton: BensonButton!
    
    @IBOutlet weak var chartTimeUnitSelectionButton: BensonButton!
    
    // Stored and computed properties.
    var logs: [MetricLog] = [] {
        
        // This is run from whatever context actually set the variable. If we are updating the variable from a background thread, then the execution of this closure occur within that thread.
        didSet {
            tableView.reloadData()
        }
        
    }

    var selectedChartMetrics: [MetricType] = [.generalFeeling] {
        didSet {
            self.updateChartAndButtons()
        }
    }

    var selectedTimeUnit: AggregationCriteria = .day {
        didSet {
            self.updateChartAndButtons()
        }
    }
    
    var selectionMode: SelectionMode = .ChartMetric
    
    // Hold a copy of the fetcher in order to cache any metric logs.
    var fetcher: Fetcher = Fetcher()
    
    // Hold an instance of the picker view at the class level so that we hold a strong reference to it, and as such it will not be lost due to ARC.
    var pickerView: UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
    
    /// Dummy text field which will be used to display the picker view.
    var dummyTextField: UITextField = UITextField(frame: CGRect.zero)
    
    /// Available metricTypes which the user can select from and view.
    var metricTypes: [MetricType] = MetricType.allCases
    
    /// Available time units which the user can select from and view.
    var timeUnits: [AggregationCriteria] = AggregationCriteria.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchMetricLogs(completionHandler: { metricLogs in
            self.log("\(metricLogs)")
            self.logs = metricLogs
        })
        
        // Configure pull to refresh.
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = Colour.primary
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        // Remove styling on the separator.
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
        
        // Configure the chartMetricSelection and chartTimeUnitSelection buttons.
        self.updateChartAndButtons()
        
        self.chartMetricSelectionButton.addTarget(self, action: #selector(self.chartMetricSelectionHandler), for: .touchUpInside)
        self.chartTimeUnitSelectionButton.addTarget(self, action: #selector(self.chartTimeUnitSelectionHandler), for: .touchUpInside)
        
        // Validate that we can add a SwiftUI view as a child of the current view.
        let uiHostingController = UIHostingController(rootView: YPDInsightSummaryView(metricOfInterest: "Vitality", percentageMOIChange: 0.24, insight: YPDInsight(metricOfInterestType: .vitality, metricOfInterestValue: 0.342, mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .activeEnergyBurned, localChange: -0.34, globalChange: -0.22, correlation: 0.58, importance: 1, timePeriod: "this week", precedingData: [])])))
        
//        self.view.addSubview(uiHostingController.view)
//        
//        uiHostingController.view.frame = self.view.bounds
    }
    
    @objc private func chartMetricSelectionHandler(){
        self.selectionMode = .ChartMetric
        self.log("All cases for MetricType: \(MetricType.allCases)")
//        self.selectedChartMetric = MetricType.allCases[(MetricType.allCases.firstIndex(of: self.selectedChartMetric)! + 1) % MetricType.allCases.count]
        self.displayMetricPickerViewForChartMetrics()
    }
    
    @objc private func chartTimeUnitSelectionHandler(){
        self.selectionMode = .TimeUnit
        self.displayMetricPickerViewForTimeUnits()
    }
    
    private func updateChartAndButtons(){
        self.chartActivityIndicator.startAnimating()
        chartMetricSelectionButton.setTitle(self.selectedChartMetrics.map { "\($0)" }.joined(separator: ", "), for: .normal)
        chartTimeUnitSelectionButton.setTitle("\(self.selectedTimeUnit)", for: .normal)
        Fetcher.sharedInstance.fetchAggregatedHealthAndCheckinData(byAggregationCriteria: self.selectedTimeUnit) { (data) in
            self.configureChartOverview(forData: data["result"], andAttributes: self.selectedChartMetrics.map { "\($0)" } , andSelectedTimeUnit: self.selectedTimeUnit)
            self.chartActivityIndicator.stopAnimating()
            
        }
    }
    
    @objc private func reloadData(){
        self.log("Reloading metric logs and chart.")
        fetcher.fetchMetricLogs(completionHandler: { metricLogs in
            self.logs = metricLogs
            self.log("Refreshed metric logs.")
            self.tableView.refreshControl?.endRefreshing()
        })
        self.updateChartAndButtons()
    }
    
    private func log(_ message: String) {
         print("[LogViewController] | \(message)")
     }
    
}

// Handle metric and time unit selection.
extension YPDInsightViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Alters the number of comparators depedending on whether '+' or '-' was tapped by the user in the UIToolbar attached to the pickerview.
    @objc private func changeComparatorValueHandler(withSender sender: Any?){
        if let barButton = sender as? UIBarButtonItem {
            if barButton.title == "+" {
                self.selectedChartMetrics.append(.generalFeeling)
            } else if barButton.title == "-" {
                self.selectedChartMetrics.removeLast()
            }
            (self.dummyTextField.inputView as? UIPickerView)?.reloadAllComponents()
            self.log("Comparators: \(self.selectedChartMetrics.count)")
        }
    }
    
    private func displayMetricPickerViewForChartMetrics(){

        dummyTextField = UITextField(frame: CGRect.zero)
        self.view.addSubview(dummyTextField)
        
        // Create a Toolbar with a 'done' button to resign the picker once completed.
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerViewDoneHandler))
        
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let incComparatorButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(self.changeComparatorValueHandler(withSender:)))
        
        let decComparatorButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(self.changeComparatorValueHandler(withSender:)))
        
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        toolbar.setItems([incComparatorButton, decComparatorButton,     spacerButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        
        
        dummyTextField.inputAccessoryView = toolbar
        dummyTextField.inputView = self.pickerView
        dummyTextField.becomeFirstResponder()
    }
    
    private func displayMetricPickerViewForTimeUnits(){
        dummyTextField = UITextField(frame: CGRect.zero)
         self.view.addSubview(dummyTextField)
        
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         
         // Create a Toolbar with a 'done' button to resign the picker once completed.
         let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pickerViewDoneHandler))
         
         let toolbar = UIToolbar()
         toolbar.barStyle = .default
         toolbar.sizeToFit()
         toolbar.setItems([spacerButton, doneButton], animated: true)
         toolbar.isUserInteractionEnabled = true
        
         dummyTextField.inputAccessoryView = toolbar
         dummyTextField.inputView = self.pickerView
         dummyTextField.becomeFirstResponder()
    }
    
    /// Called when the user taps on the 'done' button after selecting the apprpriate metric type.
    @objc private func pickerViewDoneHandler(){
        self.dummyTextField.resignFirstResponder()
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.selectionMode == .ChartMetric ? self.selectedChartMetrics.count : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.selectionMode == .ChartMetric ? self.metricTypes.count : self.timeUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.selectionMode == SelectionMode.ChartMetric ? "\(self.metricTypes[row])" : "\(self.timeUnits[row])"
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // When a row is selcted, ensure that we add to the list of selected metrics.
        switch self.selectionMode {
        case .ChartMetric:
            self.selectedChartMetrics[component] = self.metricTypes[row]
        case .TimeUnit:
            self.selectedTimeUnit = self.timeUnits[row]
        }
        
    }
    
}

extension YPDInsightViewController: UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Use twice as many cells in order to account for the separators in between each cell.
            return self.logs.count * 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row % 2 != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellSeparator")!
                cell.selectionStyle = .none
                
                return cell
                
            } else {
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "MetricLogCell")! as! CheckinCollectionViewCell
                cell.metricLog = self.logs[indexPath.row / 2]
                
                return cell
                
            }
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Only allow editing of rows which are divisble by two (logs).
            return indexPath.row % 2 == 0
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                fetcher.remove(metricLogId: self.logs[indexPath.row / 2].id ?? "") {
    //                tableView.deleteRows(at: [indexPath, IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .automatic)
                    // Checkpoint: Trying to understand why I can't add in the delete swipe animation.
                    self.logs.remove(at: indexPath.row / 2)
                    tableView.reloadData()
                }
            }
        }
    
}

/// Extend the LogViewController to support displaying the aggregated health and checkin data via CareKit charts.
extension YPDInsightViewController {
    
    /// Formatter to convert from the Date object to the string which will be represented on the axis labels. We will use a format of 'day/month', which should suffice for most of the different time units.
    var dateToStringFormatter: DateFormatter {
        let dateToStringFormatter = DateFormatter()
        dateToStringFormatter.dateFormat = "dd/MM"
        return dateToStringFormatter
    }
   
    /// Given  some JSON data representing the aggregated heath data, the selected attributes, and the TimeUnit, instantiates the chart view, if this has not already been done so, and updates the view to display the data.
    private func configureChartOverview(forData data: JSON, andAttributes attributes: [String], andSelectedTimeUnit timeUnit: AggregationCriteria) {
        
        let chartView = OCKCartesianChartView(type: .line)
        
        var dataSeries: [OCKDataSeries] = []
        
        // Dates of each metric log sample collected. This will be used to generate axis labels.
        var sampleDates: [Date] = []
        
        // For each attribute, generate the data series chart points, as well as axis labels.
        attributes.forEach {
            let (dates, chartPoints) = self.generateChartPointsAndAxisLabelDates(forAttribute: $0, andSelectedTimeUnit: timeUnit, ofAggregatedDataObjects: data.arrayValue, normalise: attributes.count > 1)
            
            sampleDates.append(contentsOf: dates)
            dataSeries.append(OCKDataSeries(dataPoints: chartPoints, title: $0, size: 3, color: Colour.chartColours.randomElement()!))
        }
        
        let horizontalAxisLabels = self.generateHorizontalAxisLabels(forCollectionDates: sampleDates)
        
//        var firstSeries: OCKDataSeries = .init(dataPoints: [CGPoint(x: 1.0, y: 3.0), CGPoint(x: 4.0, y: 5.0), CGPoint(x: 3.0, y: 4.0), CGPoint(x: 6.0, y: 1.0)], title: "First Data Series")
//        firstSeries.size = 3.0
//        firstSeries.gradientStartColor = UIColor.systemGray
//        firstSeries.gradientEndColor = UIColor.systemGray2
//
//        var secondSeries: OCKDataSeries = .init(dataPoints: [CGPoint(x: 14.0, y: 2.0), CGPoint(x: 4.0, y: 7.0), CGPoint(x: 3.0, y: 3.0), CGPoint(x: 6.0, y: 2.0)], title: "Second Data Series")
//        secondSeries.size = 1
        
        
        chartView.graphView.dataSeries = dataSeries
        //chartView.graphView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        //chartView.graphView.frame = chartViewContainer.bounds
        
        chartView.headerView.removeFromSuperview()
        self.log("Stack view items for OCKCartesianGraphView: \(chartView.contentStackView.arrangedSubviews)")
        
       // Remove unwanted header view from the ChartView's stack view.
        chartView.contentStackView.arrangedSubviews.first?.removeFromSuperview()
        
        chartView.graphView.horizontalAxisMarkers = horizontalAxisLabels.sample(withAroundNumberOfPoints: 5)
        chartView.backgroundColor = Colour.secondary
                
        chartView.frame = self.chartViewContainer.bounds
                
        //chartView.headerView.titleLabel.text = "My Sample Chart"
        chartView.headerView.isHidden = true
        
        // Re-instantiate the chart view as a subview of the container.
        self.chartViewContainer.subviews.forEach { $0.removeFromSuperview() }
        
        self.chartViewContainer.addSubview(chartView)
        
    }
    
    /// Given an array of Dates corresponding to date samples when metric logs were taken, cleans out duplicates and generates horizontal axis labels.
    private func generateHorizontalAxisLabels(forCollectionDates dates: [Date]) -> [String] {
        return Array(Set(dates)).sorted(by: { (firstDate, secondDate) -> Bool in
            return firstDate.timeIntervalSince1970 < secondDate.timeIntervalSince1970
        }).map { self.dateToStringFormatter.string(from: $0) }
    }
    
    /// Generates a series of chart points for a given attribute and array of aggregated health data & checkin objects.
    /// Parameters:
    /// - filterOutZeros: Filters out points which have a '0' value for the y axis. Useful for healthDataObjects where a '0' indicates the lack of a response.
    /// Returns:
    /// - Tuple ([String], [CGPoint]) denoting the horizontal axis labels as well as the individual data points.
    private func generateChartPointsAndAxisLabelStrings(forAttribute attribute: String, andSelectedTimeUnit timeUnit: AggregationCriteria, ofAggregatedDataObjects data: [JSON], filterOutZeros: Bool = true, normalise: Bool = false) -> ([String], [CGPoint]) {
       
        let (dates, points) = self.generateChartPointsAndAxisLabelDates(forAttribute: attribute, andSelectedTimeUnit: timeUnit, ofAggregatedDataObjects: data, filterOutZeros: filterOutZeros, normalise: normalise)
        
        return (dates.map { self.dateToStringFormatter.string(from: $0) }, points)
    }
    
    /// Generates the chart points to be used for the OCKDataSeries, as well as an array of Dates which can be concatenated amongst all attributes in order to generate all required horizontal axis labels.
    private func generateChartPointsAndAxisLabelDates(forAttribute attribute: String, andSelectedTimeUnit timeUnit: AggregationCriteria, ofAggregatedDataObjects data: [JSON], filterOutZeros: Bool = true, normalise: Bool = false) -> ([Date], [CGPoint]) {
        
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
        self.log("Generated chart points: \(chartPoints)")
        
        return (chartPoints.map { $0.0 }, chartPoints.map { CGPoint(x: $0.1.x, y: $0.1.y / CGFloat(normalise ? largestYValue : 1)) })
    }
}
