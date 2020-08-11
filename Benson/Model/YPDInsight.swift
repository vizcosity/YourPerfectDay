//
//  YPDInsight.swift
//  Benson
//
//  Created by Aaron Baw on 11/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents an insight / anomaly for a given metric of interest.
class YPDInsight: Identifiable, PrettyPrintable {
    
    /// The MOI type. This maps to the 'desired_metric' in the response JSON.
    var metricOfInterestType: YPDCheckinType
    
    /// The value assocaited with the metric of interest (e.g., the anomaly value).
    var metricOfInterestValue: Double
    
    /// The change in the metric of interest from the local mean to the global mean.
    var metricOfInterestGlobalChange: Double
    
    /// Global mean for the metric of interest.
    var metricOfInterestGlobalMean: Double
    
    /// Local mean.
    var metricOfInterestLocalMean: Double
    
    /// The local change (line of best fit) for the metric.
    var metricOfInterestLocalChange: Double

    /// The date associated with the insight.
    var date: Date
    
    /// The human readable date associated with the given insight. (If the anomaly was detected today, it highlights so - otherwise, it describes the timeSince in human readable terms (e.g. "3 days ago").
    var humanReadableDate: String {
        let checkinDate = moment(self.date).startOf("day");
        let today = moment(Date()).startOf("day");
        let timeSinceString = checkinDate.isSame(today) ? "Today" : checkinDate.from(today)
        return timeSinceString
    }
    
    /// Abbreviated date (DD/MM) for the insight.
    var abbreviatedDateString: String {
        let checkinDate = moment(self.date).startOf("day")
        let shortDateString = checkinDate.format("DD/MM")
        return shortDateString
    }
    
    /// The time period associated with the metric.
    var timePeriod: String = "while"
    
    /// A list of the most important metrics associated with the insight / anomaly.
    var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
    
    init(
        metricOfInterestType: YPDCheckinType,
        metricOfInterestValue: Double,
        metricOfInterestGlobalChange: Double,
        metricOfInterestGlobalMean: Double,
        metricOfInterestLocalChange: Double,
        metricOfInterestLocalMean: Double,
        date: Date,
        timePeriod: String = "while",
        mostImportantAnomalyMetrics: [YPDAnomalyMetric]
    ) {
        self.metricOfInterestType = metricOfInterestType
        self.metricOfInterestValue = metricOfInterestValue
        self.metricOfInterestGlobalChange = metricOfInterestGlobalChange
        self.metricOfInterestGlobalMean = metricOfInterestGlobalMean
        self.metricOfInterestLocalChange = metricOfInterestLocalChange
        self.metricOfInterestLocalMean = metricOfInterestLocalMean
        self.date = date
        self.timePeriod = timePeriod
        self.mostImportantAnomalyMetrics = mostImportantAnomalyMetrics
    }
    
    convenience init(json: JSON){
        let metricOfInterestType = YPDCheckinType(rawValue: json["desired_metric"].stringValue) ?? .unknown
        let metricOfInterestValue = json["anomaly_value"].doubleValue
        
        let metricOfInterestGlobalChange = json["anomaly_metrics"]["global_percentage_change"].doubleValue
        let metricOfInterestGlobalMean = json["anomaly_metrics"]["global_mean"].doubleValue
        
        let metricOfInterestLocalChange = json["anomaly_metrics"]["local_percentage_change"].doubleValue
        let metricOfInterestLocalMean = json["anomaly_metrics"]["local_mean"].doubleValue
        
        let date = Date.from(isoString: json["anomaly_start_of_date"].stringValue)
                    
        // Fetch the dates associated with the preceding data.
        let precedingDataDates: [Date] = json["preceding_data"]["startOfDate"].arrayValue.map { Date.from(isoString: $0.stringValue) }
                
        var timePeriod: String = "while"
        
        if precedingDataDates.count >= 2 {
            timePeriod = moment(precedingDataDates.first!).from(precedingDataDates.last!, true)
        }
        
        let mostImportantMetrics = json["most_important_metrics_array"].arrayValue.map {
            
            YPDAnomalyMetric(json: $0, timePeriod: timePeriod, precedingData: zip(precedingDataDates, json["most_important_preceding_data"][$0["metric"].stringValue].arrayValue.map{$0.doubleValue}).map { $0 }
            )
            
        }
        
        self.init(
            metricOfInterestType: metricOfInterestType,
            metricOfInterestValue: metricOfInterestValue,
            metricOfInterestGlobalChange: metricOfInterestGlobalChange,
            metricOfInterestGlobalMean: metricOfInterestGlobalMean,
            metricOfInterestLocalChange: metricOfInterestLocalChange,
            metricOfInterestLocalMean: metricOfInterestLocalMean,
            date: date,
            timePeriod: timePeriod,
            mostImportantAnomalyMetrics: mostImportantMetrics
        )

    }
}

/// Represents a change in a given metric; used for displaying insights to the user.
class YPDAnomalyMetric: PrettyPrintable, Identifiable {
    
    var id = UUID()
    
    /// The metric attribute associated with the current insight.
    var metricAttribute: YPDCheckinType
    
    var localChange: Double
    var localMean: Double
    var globalChange: Double
    var globalMean: Double
    var timePeriod: String
    var importance: Double
    var correlation: Double
    
    /// The metric attribute which this appears to be affecting.
    var affectingMetricAttribute: YPDCheckinType?
    
    var precedingData: [(Date, Double)]
    
    
    /// Describes the change seen over the period for which the anomaly has been detected.
    var changeOverLocalPeriodDescription: String? {
        
        guard let startingValue = self.precedingData.first?.1, let endingValue = self.precedingData.last?.1 else {
            return nil
        }
        
        return "Over the last \(self.timePeriod), your \(self.metricAttribute.humanReadable) has \(self.localChangeType) by \(self.localChange.formattedAsPercentage) (going from \(startingValue.rounded(toDecimalPlaces: 2)) to \(endingValue.rounded(toDecimalPlaces: 2))), with a mean of \(self.localMean.rounded(toDecimalPlaces: 2))."
    }
    
    /// Describes the current anomaly within the context of the global mean.
    var changeOverGlobalPeriodDescription: String {
        return "Your \(self.metricAttribute.humanReadable) has \(self.globalChangeType) from the all-time average of \(self.globalMean.rounded(toDecimalPlaces: 2)) to an average of \(self.localMean.rounded(toDecimalPlaces: 2)) within the last \(self.timePeriod)."
    }
    
    /// Describes how the current anomaly metric relates to the affecting metric attribute, in terms of the correlation and importance.
    var correlationToAffectingMetricAttributeDescription: String? {
        guard let affectingMetricAttribute = self.affectingMetricAttribute else {
            return nil
        }
        return "This appears to be \(self.correlationTypeString) with \(affectingMetricAttribute.humanReadable) (\(self.correlation.formattedAsPercentage))"
    }
    
    var correlationTypeString: String {
        guard self.correlation != 0 else {
            return "uncorrelated"
        }
        return self.correlation > 0 ? "positively correlated" : "negatively correlated"
    }
    
    var localChangeType: String {
        if self.localChange == 0 {
            return "changed"
        }
        return self.localChange >= 0 ? "increased" : "decreased"
    }
    
    var globalChangeType: String {
         if self.globalChange == 0 {
             return "changed"
         }
         return self.globalChange >= 0 ? "increased" : "decreased"
     }
    
        
    init(metricAttribute: YPDCheckinType, affectingMetricAttribute: YPDCheckinType? = nil, localChange: Double, localMean: Double, globalChange: Double, globalMean: Double, correlation: Double, importance: Double, timePeriod: String, precedingData: [(Date, Double)]){
        self.metricAttribute = metricAttribute
        self.affectingMetricAttribute = affectingMetricAttribute
        self.localChange = localChange
        self.localMean = localMean
        self.globalChange = globalChange
        self.globalMean = globalMean
        self.correlation = correlation
        self.importance = importance
        self.timePeriod = timePeriod
        self.precedingData = precedingData
    }

    convenience init(json: JSON, timePeriod: String, precedingData: [(Date, Double)]) {
        self.init(metricAttribute: YPDCheckinType(rawValue: json["metric"].stringValue)!, localChange: json["local_percentage_change"].doubleValue, localMean: json["local_mean"].doubleValue, globalChange: json["global_percentage_change"].doubleValue, globalMean: json["global_mean"].doubleValue, correlation: json["correlation"].doubleValue, importance: json["importance"].doubleValue, timePeriod: timePeriod, precedingData: precedingData)

    }
    
}
