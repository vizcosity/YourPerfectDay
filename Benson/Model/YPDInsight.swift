//
//  YPDInsight.swift
//  Benson
//
//  Created by Aaron Baw on 11/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON

struct YPDInsightResponse: Decodable {
    let success: Bool
    let data: [YPDInsight]
}

/// Represents an insight / anomaly for a given metric of interest.
struct YPDInsight: Identifiable, PrettyPrintable {
    
    var id: String?

    
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
    
    init(json: JSON){
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

/// Decodable YPDInsight extension.
extension YPDInsight: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case desiredMetric = "desired_metric"
        case anomalyIndex = "anomaly_index"
        case anomalyValue = "anomaly_value"
        case anomalyMetrics = "anomaly_metrics"
        case anomalyStartOfDate = "anomaly_start_of_date"
        case precedingData = "preceding_data"
        case mostImportantMetricsDict = "most_important_metrics_dict"
        case mostImportantMetricsArray = "most_important_metrics_array"
        case mostImportantPrecedingData = "most_important_preceding_data"
        
        enum AnomalyMetricCodingKeys: String, CodingKey {
            case correlation
            case localPercentageChange = "local_percentage_change"
            case localMean = "local_mean"
            case globalPercentageChange = "global_percentage_change"
            case globalMean = "global_mean"
            case importance
        }
        
        enum MostImportantMetricsCodingKeys: String, CodingKey {
            case correlation
            case localPercentageChange = "local_percentage_change"
            case localMean = "local_mean"
            case globalPercentageChange = "global_percentage_change"
            case globalMean = "global_mean"
            case importance, metric
        }
        
        enum PrecedingDataKeys: String, CodingKey {
            case activeEnergyBurned, basalEnergyBurned, caloricIntake, dietaryCarbohydrates, dietaryFats, dietaryProtein, exerciseMinutes, hrv, lowHeartRateEvents, restingHeartRate, sleepHours, standingMinutes, stepCount, weight, generalFeeling, mood, energy, focus, vitality, startOfDate
        }
        
    }
    
    init(from decoder: Decoder) throws {
        
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.metricOfInterestType = YPDCheckinType(try dataContainer.decode(String.self, forKey: .desiredMetric))
        self.metricOfInterestValue = try dataContainer.decode(Double.self, forKey: .anomalyValue)
        
        // Why is it that we need to refer to 'self' when referencing an enum that we would like our container to be keyed by, or when referencing a type that we would like to be decoded?
        let anomalyMetricsContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.AnomalyMetricCodingKeys.self, forKey: .anomalyMetrics)
        self.date = Date.from(isoString: try dataContainer
                                .decode(String.self, forKey: .anomalyStartOfDate))
        self.metricOfInterestGlobalChange = try anomalyMetricsContainer.decode(Double.self, forKey: .globalPercentageChange)
        self.metricOfInterestGlobalMean = try anomalyMetricsContainer.decode(Double.self, forKey: .globalMean)
        self.metricOfInterestLocalChange = try anomalyMetricsContainer.decode(Double.self, forKey: .localPercentageChange)
        self.metricOfInterestLocalMean = try anomalyMetricsContainer.decode(Double.self, forKey: .localMean)
        
        let precedingDataContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.PrecedingDataKeys.self, forKey: .precedingData)
        
        let precedingDataDates = (try precedingDataContainer.decode([String].self, forKey: .startOfDate)).map(Date.from(isoString:))
        
        self.timePeriod = "while"
        
        // Calculating the 'time period' string.
        if precedingDataDates.count >= 2 {
            self.timePeriod = moment(precedingDataDates.first!).from(precedingDataDates.last!, true)
        }
        
        self.mostImportantAnomalyMetrics = try dataContainer.decode([YPDAnomalyMetric].self, forKey: .mostImportantMetricsArray)
        
    }
    
}

/// Extensions for displaying date information.
extension YPDInsight {
    
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
    
}

/// Represents a change in a given metric; used for displaying insights to the user.
struct YPDAnomalyMetric: PrettyPrintable, Identifiable {
    
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
    
    var precedingData: [(Date, Double)] = []
        
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

    init(json: JSON, timePeriod: String, precedingData: [(Date, Double)]) {
        self.init(metricAttribute: YPDCheckinType(json["metric"].stringValue), localChange: json["local_percentage_change"].doubleValue, localMean: json["local_mean"].doubleValue, globalChange: json["global_percentage_change"].doubleValue, globalMean: json["global_mean"].doubleValue, correlation: json["correlation"].doubleValue, importance: json["importance"].doubleValue, timePeriod: timePeriod, precedingData: precedingData)
    }
    
}

extension YPDAnomalyMetric: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case correlation
        case localPercentageChange = "local_percentage_change"
        case localMean = "local_mean"
        case globalPercentageChange = "global_percentage_change"
        case globalMean = "global_mean"
        case importance
        case metricAttribute = "metric"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.localChange = try container.decode(Double.self, forKey: .localPercentageChange)
        self.localMean = try container.decode(Double.self, forKey: .localMean)
        self.globalChange = try container.decode(Double.self, forKey: .globalPercentageChange)
        self.globalMean = try container.decode(Double.self, forKey: .globalMean)
        self.correlation = try container.decode(Double.self, forKey: .correlation)
        self.importance = try container.decode(Double.self, forKey: .importance)
        
        // We need to ensure that the metric attribute is contained within the object - as there are instances where this may not appear (depending which version of the anomaly metric is being decoded).
        let metricAttributeString = try container.decodeIfPresent(String.self, forKey: .metricAttribute)
        if let metricAttributeString = metricAttributeString {
            self.metricAttribute = YPDCheckinType(metricAttributeString)
        } else {
            self.metricAttribute = .unknown
        }
        
        self.timePeriod = "some time ago"
        
    }
    
}


/// Computed properties for describing the anomaly metric.
extension YPDAnomalyMetric {
    
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
    
}

extension YPDInsight {
    static var mockedDietaryProtein: YPDInsight {
        YPDInsight(
            metricOfInterestType: .dietaryProtein,
            metricOfInterestValue: 3,
            metricOfInterestGlobalChange: 0.5,
            metricOfInterestGlobalMean: 3.42,
            metricOfInterestLocalChange: 2.12,
            metricOfInterestLocalMean: 1.24,
            date: Date(),
            mostImportantAnomalyMetrics: [
                .init(
                    metricAttribute: .caloricIntake,
                    localChange: 1.3,
                    localMean: 1.1,
                    globalChange: 0.3,
                    globalMean: 1.3,
                    correlation: 0.7,
                    importance: 1,
                    timePeriod: "a while ago",
                    precedingData: [(Date(), 1.2)]
                )
            ]
        )
    }
    
    static var mockedGeneralFeeling: YPDInsight {
        YPDInsight(metricOfInterestType: .generalFeeling, metricOfInterestValue: 2.342, metricOfInterestGlobalChange: 0.34, metricOfInterestGlobalMean: 3,metricOfInterestLocalChange: 1.82, metricOfInterestLocalMean: 2, date: Date(timeIntervalSinceNow: -199999),  mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .caloricIntake, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .dietaryCarbohydrates, localChange: -0.83, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .lowHeartRateEvents, localChange: 0.33, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .sleepHours, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: [])])
    }
}
