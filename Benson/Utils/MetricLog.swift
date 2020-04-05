//
//  File.swift
//  Benson
//
//  Created by Aaron Baw on 11/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Class for a single Metric Prompt.
class MetricPrompt {
    var metricId: String
    var metricTitle: String
    var responses: [MetricResponse]
    
    init(metricId: String, metricTitle: String, responses: [MetricResponse]) {
        self.metricId = metricId
        self.responses = responses
        self.metricTitle = metricTitle
    }
    
    /// Given a JSON response from the web api, returns a MetricPrompt object.
    public static func fromJSON(dict: [String: Any]) -> MetricPrompt {
        
        // Checkpoint: refactoring code to enable easy instantiation of MetricPrompt objects from dictionaries obtained through GET requests to the backend via AlamoFire.
        var responses: [MetricResponse] = []
        var metricId: String = ""
        var metricTitle: String = ""
        if let responsesJSON = dict["responses"] as? [[String: Any]], let metricIdJSON = dict["metricId"] as? String, let metricTitleJSON = dict["title"] as? String {
            responses = responsesJSON.map({ (responseJSON) -> MetricResponse in
                var metricResponse = MetricResponse(type: .unknown, value: 0)
                if let title = responseJSON["title"] as? String, let value = responseJSON["value"] as? Double {
                        metricResponse = MetricResponse(type: title, value: value)
                    }
                    return metricResponse
            // Filter out metric responses where we fail to unwrap the title and value optionals.
            }).filter { $0.type != .unknown }
         metricId = metricIdJSON
         metricTitle = metricTitleJSON
        }
        
        return MetricPrompt(metricId: metricId, metricTitle: metricTitle, responses: responses)
    }
}

/// Describes the different options a user can select for a given metric prompt.
class MetricResponse {
    var type: MetricType
    var value: Double
    init(type: MetricType, value: Double) {
        self.type = type
        self.value = value
    }
    
    init(type: String, value: Double){
        self.type = MetricType.init(rawValue: type) ?? .unknown
        self.value = value
    }
}

// Data model for a single attribute.
class MetricAttribute: CustomStringConvertible {
    
    var description: String {
        get {
            return "[MetricAttribute] \(name): (\(value)/\(average))"
        }
    }
    
//    static let maxValue = 5
    var name: String
    var value: Double
    var average: Double
    
    /// The maximum value which can be observed or recorded for the given metric.
    var maxValue: Double = 5
    
    init(name: String, value: Double, average: Double){
        self.name = name
        self.value = value
        self.average = average
    }
    
    convenience init(name: String, value: Double) {
        self.init(name: name, value: value, average: value)
    }
}


// Data model for metric logs.
class MetricLog: CustomStringConvertible {
    
    var description: String {
        get {
            return "\(self.metrics): \(self.timeSince)"
        }
    }
    
    var id: String?
    var metrics: [MetricAttribute] = []
    var timestamp: Date?
    var timeSince: String = "Some time ago"
    
    /// Summary data obtained from healthkit for the day when the log was recorded.
    var enrichedData: BensonHealthDataObject?
    
    init(metrics: [MetricAttribute], timeSince: String, id: String? = nil){
        self.metrics = metrics
        self.timeSince = timeSince
        self.id = id
    }
    
    convenience init(metrics: [MetricAttribute], timeSince: String, timestamp: Int, id: String? = nil) {
        self.init(metrics: metrics, timeSince: timeSince)
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
        self.id = id
    }
    
}

/// The measurement or metric type.
// TODO: Refactor so that the metric types are inferred from the keys of the aggregated healthDataObject, from the backend.
enum MetricType: String, CaseIterable {
    
    case generalFeeling
    case mood
    case energy
    case focus
    case vitality
    
    case hrv
    case caloricIntake
    case basalEnergyBurned
    case activeEnergyBurned
    case dietaryCarbohydrates
    case dietaryFats
    case dietaryProtein
    case lowHeartRateEvents
    case restingHeartRate
    case sleepHours
    case weight
    
    // Unknown case, occurring when we fail to initialise via a string value.
    case unknown
    
    /// Returns human readable sentences describing the metric type, converting from camelCase to a sentence.
    var humanReadable: String {
        return self.rawValue.map { "\($0.isUppercase ? " \($0)" : "\($0)")" }.joined(separator: "").capitalized
    }
}

// EXAMPLE YPD Anomaly response from API:
// {
//    "anomaly_index": 3,
//    "desired_metric": "vitality",
//    "anomaly_value": 3.407894736842105,
//    "preceding_data": {
//        "startOfDate": {
//            "0": "2020-03-08T00:00:00.000Z",
//            "1": "2019-12-01T00:00:00.000Z",
//            "2": "2019-12-08T00:00:00.000Z"
//        },
//        "activeEnergyBurned": {
//            "0": 340.978999999999,
//            "1": 393.3909999999995,
//            "2": 615.9937142857161
//        },
//        "basalEnergyBurned": {
//            "0": 1417.6336666666737,
//            "1": 1631.345999999996,
//            "2": 1678.8900000000124
//        },
//        "caloricIntake": {
//            "0": 1038.1900024414062,
//            "1": 0,
//            "2": 2123.3472791399277
//        },
//        "dietaryCarbohydrates": {
//            "0": 78.72500109672546,
//            "1": 0,
//            "2": 203.85954138210843
//        },
//        "dietaryFats": {
//            "0": 43.48499917984009,
//            "1": 0,
//            "2": 83.09073025839669
//        },
//        "dietaryProtein": {
//            "0": 79.49899899959564,
//            "1": 0,
//            "2": 134.85908678599765
//        },
//        "hrv": {
//            "0": 59.27884052417896,
//            "1": 70.9596939086914,
//            "2": 50.50681503775979
//        },
//        "lowHeartRateEvents": {
//            "0": 3.333333333333333,
//            "1": 7,
//            "2": 2.25
//        },
//        "restingHeartRate": {
//            "0": 26.333333333333336,
//            "1": 37,
//            "2": 48
//        },
//        "sleepHours": {
//            "0": 8.941898148148148,
//            "1": 9.800555555555555,
//            "2": 6.369361111111111
//        },
//        "weight": {
//            "0": 0,
//            "1": 0,
//            "2": 40.7335028966626
//        },
//        "generalFeeling": {
//            "0": 2.2,
//            "1": 2.333333333333333,
//            "2": 2.6896551724137927
//        },
//        "mood": {
//            "0": 2.8,
//            "1": 3,
//            "2": 2.862068965517242
//        },
//        "energy": {
//            "0": 1.9999999999999998,
//            "1": 2.6666666666666665,
//            "2": 2.5862068965517238
//        },
//        "focus": {
//            "0": 2.8,
//            "1": 3,
//            "2": 2.750000000000001
//        },
//        "vitality": {
//            "0": 2.4499999999999997,
//            "1": 2.7499999999999996,
//            "2": 2.72198275862069
//        }
//    },
//    "most_important_metrics": {
//        "correlation": {
//            "weight": 0.4249991890880587
//        },
//        "local_percentage_change": {
//            "weight": -5.999999999999999
//        },
//        "global_percentage_change": {
//            "weight": -0.44548147344884026
//        },
//        "importance": {
//            "weight": 1
//        }
//    },
//    "most_important_preceding_data": {
//        "weight": {
//            "0": 0,
//            "1": 0,
//            "2": 40.7335028966626
//        }
//    }
//}

/// Represents an insight / anomaly for a given metric of interest.
class YPDInsight {
    
    /// The MOI type.
    var metricOfInterestType: MetricType
    
    /// The value assocaited with the metric of interest (e.g., the anomaly value).
    var metricOfInterestValue: Double
    
    /// A list of the most important metrics associated with the insight / anomaly.
    var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
    
    init(metricOfInterestType: MetricType, metricOfInterestValue: Double, mostImportantAnomalyMetrics: [YPDAnomalyMetric] ) {
        self.metricOfInterestType = metricOfInterestType
        self.metricOfInterestValue = metricOfInterestValue
        self.mostImportantAnomalyMetrics = mostImportantAnomalyMetrics
    }
    
    convenience init(json: JSON){
        let metricOfInterestType = MetricType(rawValue: json["desired_metric"].stringValue) ?? .unknown
        let metricOfInterestValue = json["anomaly_value"].doubleValue
//        let metricOfInterestValue = MetricResponse(type: metricOfInterestType, value: metricOfInterestRawValue)
                
        let mostImportantMetricJSONDict = json["most_important_metrics"].dictionaryValue
        
//        var mostImportantAnomalyMetricsDict: [String: Any]
        var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
        
        // Fetch the most important metrics and their corresponding preceding data.
        let mostImportantPrecedingDataJSONDict = json["most_important_preceding_data"].dictionaryValue
       
        mostImportantPrecedingDataJSONDict.keys.forEach { metric in
            
            let metricType = MetricType(rawValue: metric) ?? .unknown
            let precedingDataDict = mostImportantPrecedingDataJSONDict[metric]?.dictionaryValue
            
            // Iterate over all of the values, and create an array.
            let precedingDataAsDoubles = precedingDataDict?.values.map { $0.doubleValue } ?? []
            print("Preceding data as doubles: \(precedingDataAsDoubles) for metric \(metric)")
            
            // Fetch the importance, correlation, local & global percentage changes. If any of these are nil and not set for some reason, then we skip adding the metric - as we only want to display most important metrics / individual metric insights if there is a corresponding local, gobal percentage change, and an importance & correlation.
            guard let importance = mostImportantMetricJSONDict[metric]?.dictionaryValue["importance"]?.doubleValue else { return }
            guard let correlation = mostImportantMetricJSONDict[metric]?.dictionaryValue["correlation"]?.doubleValue else { return }
            guard let localPercentageChange = mostImportantMetricJSONDict[metric]?.dictionaryValue["local_percentage_change"]?.doubleValue else { return }
            guard let globalPercentageChange = mostImportantPrecedingDataJSONDict[metric]?.dictionaryValue["global_percentage_change"]?.doubleValue else { return }
            
            // TODO: Add a server-side property which calculates the time horizon for the data (e.g. this week, last week, this month, this quarter, etc). For now, we will assume that all insights have been deduced for the current week.
            
            
            // Convert preceding data double values into a MetricResponse.
            let anomalyMetric = YPDAnomalyMetric(metricAttribute: metricType, localChange: localPercentageChange, globalChange: globalPercentageChange, correlation: correlation,
                                                 importance: importance, timePeriod: "this week", precedingData: precedingDataAsDoubles)
            
            mostImportantAnomalyMetrics.append(anomalyMetric)
        }
        
        self.init(metricOfInterestType: metricOfInterestType, metricOfInterestValue: metricOfInterestValue, mostImportantAnomalyMetrics: mostImportantAnomalyMetrics)

    }
}


/// Represents a change in a given metric; used for displaying insights to the user.
class YPDAnomalyMetric {
    
    /// The metric attribute associated with the current insight.
    var metricAttribute: MetricType
    
    var localChange: Double
    var globalChange: Double
    var timePeriod: String?
    var importance: Double
    var correlation: Double
    
    var precedingData: [Double]
    
    init(metricAttribute: MetricType, localChange: Double, globalChange: Double, correlation: Double, importance: Double, timePeriod: String, precedingData: [Double]){
        self.metricAttribute = metricAttribute
        self.localChange = localChange
        self.globalChange = globalChange
        self.correlation = correlation
        self.importance = importance
        self.timePeriod = timePeriod
        self.precedingData = precedingData
    }
    
}
