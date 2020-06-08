//
//  File.swift
//  Benson
//
//  Created by Aaron Baw on 11/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftUI

/// YPDCheckinPrompts contain a question which the user will need to respond to with a subjective measurement of how they feel with regards to a certain metric, such as `focus`, `energy`, `mood`, etc.
class YPDCheckinPrompt: Identifiable, ObservableObject {
    
    var id = UUID()
    var type: String
    var readableTitle: String
    var responseOptions: [YPDCheckinResponseOption]
    @State var responseValue: YPDCheckinResponseValue
    
    init(type: String, readableTitle: String, responseOptions: [YPDCheckinResponseOption]) {
        self.type = type
        self.responseOptions = responseOptions
        self.responseValue = YPDCheckinResponseValue(type: type, value: 0)
        self.readableTitle = readableTitle
    }
    
    /// Given a JSON response from the web api, returns a MetricPrompt object.
    public static func fromJSON(dict: JSON) -> YPDCheckinPrompt {
        
        // Checkpoint: refactoring code to enable easy instantiation of MetricPrompt objects from dictionaries obtained through GET requests to the backend via AlamoFire.
        // NOTE: The metric Id in this instance actually corresponds to the metric type (e.g. generalFeeling, mood, and so on).
        let type: String = dict["metricId"].stringValue
        let readableTitle: String = dict["title"].stringValue
        
        let responsesJSON = dict["responses"].arrayValue
        
        // print("Obtained responseJSON: \(responsesJSON)")
        
        let responseOptions: [YPDCheckinResponseOption] = responsesJSON.map { (responseJSON) -> YPDCheckinResponseOption in
            return YPDCheckinResponseOption(type: type, label: responseJSON["title"].stringValue, value: responseJSON["value"].doubleValue)
        }.filter { $0.type != .unknown }
                
        return YPDCheckinPrompt(type: type, readableTitle: readableTitle, responseOptions: responseOptions)
    }
}

// Add support for Equatability so that we can find the index of specific checkin prompts.
extension YPDCheckinPrompt: Equatable {
    static func == (lhs: YPDCheckinPrompt, rhs: YPDCheckinPrompt) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

/// Describes the different options a user can select for an individual checkin prompt attribute.
/// Example:
///     I'm Feeling:
///         "Horrible" (0), "Meh" (1), "Okay" (2), "Not Bad" (3), "Great" (4)
class YPDCheckinResponseOption {
    
    /// The parent type which the response option belongs to.
    var type: YPDCheckinType
    
    /// The label for the response option (e.g. "Horrible")
    var label: String
    
    /// The value for the response option (e.g. 0)
    var value: Double
    
    init(type: YPDCheckinType, label: String, value: Double) {
        self.type = type
        self.label = label
        self.value = value
    }
    
    init(type: String, label: String, value: Double){
        self.type = YPDCheckinType(rawValue: type) ?? .unknown
        self.label = label
        self.value = value
    }
    
}

/// Contains the value for a single attribute (e.g., `Mood`, `Energy`, etc) within a YPD Checkin.
class YPDCheckinResponseValue: ObservableObject {
    
//    static let maxValue = 5
//    var readableTitle: String
    // CHECKPOINT: Attempting to ensure that the slider value selected is bound to the response value instead of being kept separate - so that it can all be contained within the data model.
//    @State var _selectedValue: Float = 0
//
//    var value: Double {
//        get {
//            return Double(self._selectedValue)
//        }
//
//        set {
//            self._selectedValue = Float(newValue)
//        }
//    }
    var value: Double
    var average: Double?
    var type: YPDCheckinType
    
    /// The maximum value which can be observed or recorded for the given metric.
    var maxValue: Double = 5
    
    /// Initialises an empty, unsubmitted YPDCheckinAttributeValue option based off of the accompanied response option. This will be populated once the user records their response value.
    init(selectedResponseOption: YPDCheckinResponseOption) {
        // self.readableTitle = selectedResponseOption.readableTitle
        self.type = selectedResponseOption.type
        self.value = 0
    }
    
    init(type: YPDCheckinType, value: Double, average: Double? = nil){
        // self.readableTitle = readableTitle
        self.average = average ?? value
        self.type = type
        self.value = value
    }
    
    convenience init(type: String, value: Double, average: Double? = nil){
        self.init(type: YPDCheckinType(rawValue: type) ?? .unknown, value: value, average: average)
    }
}

// Add a description to repsonse values.
extension YPDCheckinResponseValue: CustomStringConvertible {
    var description: String {
        get {
            return "[YPDResponseValue] \(self.type.humanReadable): (\(self.value)/\(self.average ?? self.value))"
        }
    }
}

// Ensure that YPDCheckinResponseValues are Hashable by providing a custom hash() implementation, since @State values cannot be used automatically.
extension YPDCheckinResponseValue: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
}

// Ensure MetricAttribute is equatable.
extension YPDCheckinResponseValue: Equatable {
    
    static func == (lhs: YPDCheckinResponseValue, rhs: YPDCheckinResponseValue) -> Bool {
        return
            // lhs.readableTitle == rhs.readableTitle &&
            lhs.value == rhs.value &&
            lhs.average == rhs.average &&
            lhs.type == rhs.type
    }
    
    
}


/// A YPDCheckin object contains a collection of individual attribute values which the user has recorded for each given attribute type.
struct YPDCheckin: CustomStringConvertible {
    
    var description: String {
        get {
            return "\(self.attributeValues): \(self.timeSince)"
        }
    }
    
    var id = UUID()
    var type: String?
    var attributeValues: [YPDCheckinResponseValue] = []
    var timestamp: Date?
    var timeSince: String = "Some time ago"
    
    /// Summary data obtained from healthkit for the day when the log was recorded.
    var enrichedData: BensonHealthDataObject?
    
    init(attributeValues: [YPDCheckinResponseValue], timeSince: String, type: String? = nil){
        self.attributeValues = attributeValues
        self.timeSince = timeSince
        self.type = type
    }
    
    init(attributeValues: [YPDCheckinResponseValue], timeSince: String, timestamp: Int, type: String? = nil) {
        self.init(attributeValues: attributeValues, timeSince: timeSince)
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
        self.type = type
    }
    
    public func copy() -> YPDCheckin {
        var copiedMetric = YPDCheckin(attributeValues: self.attributeValues, timeSince: self.timeSince, type: self.type)
            
        copiedMetric.timestamp = self.timestamp
        copiedMetric.enrichedData = self.enrichedData
        
        return copiedMetric
    }
}

/// Ensure that Metric Logs are hashable so that we can use them in ForEach loops in SwiftUI.
extension YPDCheckin: Hashable {
    
    public func equals(otherMetricLog: YPDCheckin) -> Bool {
        return self.type == otherMetricLog.type &&
            self.timestamp == otherMetricLog.timestamp &&
            self.timeSince == otherMetricLog.timeSince
    }
    
    static func == (lhs: YPDCheckin, rhs: YPDCheckin) -> Bool {
        return lhs.equals(otherMetricLog: rhs) &&
            lhs.attributeValues.elementsEqual(rhs.attributeValues, by: { (lhsMetric, rhsMetric) -> Bool in
                return lhsMetric == rhsMetric
            })
    }
    
    
}

/// The measurement or metric type.
// TODO: Refactor so that the metric types are inferred from the keys of the aggregated healthDataObject, from the backend.
enum YPDCheckinType: String, CaseIterable, Hashable {
    
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
    var metricOfInterestType: YPDCheckinType
    
    /// The value assocaited with the metric of interest (e.g., the anomaly value).
    var metricOfInterestValue: Double
    
    /// A list of the most important metrics associated with the insight / anomaly.
    var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
    
    init(metricOfInterestType: YPDCheckinType, metricOfInterestValue: Double, mostImportantAnomalyMetrics: [YPDAnomalyMetric] ) {
        self.metricOfInterestType = metricOfInterestType
        self.metricOfInterestValue = metricOfInterestValue
        self.mostImportantAnomalyMetrics = mostImportantAnomalyMetrics
    }
    
    convenience init(json: JSON){
        let metricOfInterestType = YPDCheckinType(rawValue: json["desired_metric"].stringValue) ?? .unknown
        let metricOfInterestValue = json["anomaly_value"].doubleValue
//        let metricOfInterestValue = MetricResponse(type: metricOfInterestType, value: metricOfInterestRawValue)
                
        let mostImportantMetricJSONDict = json["most_important_metrics"].dictionaryValue
        
//        var mostImportantAnomalyMetricsDict: [String: Any]
        var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
        
        // Fetch the most important metrics and their corresponding preceding data.
        let mostImportantPrecedingDataJSONDict = json["most_important_preceding_data"].dictionaryValue
       
        mostImportantPrecedingDataJSONDict.keys.forEach { metric in
            
            let metricType = YPDCheckinType(rawValue: metric) ?? .unknown
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
    var metricAttribute: YPDCheckinType
    
    var localChange: Double
    var globalChange: Double
    var timePeriod: String?
    var importance: Double
    var correlation: Double
    
    var precedingData: [Double]
    
    init(metricAttribute: YPDCheckinType, localChange: Double, globalChange: Double, correlation: Double, importance: Double, timePeriod: String, precedingData: [Double]){
        self.metricAttribute = metricAttribute
        self.localChange = localChange
        self.globalChange = globalChange
        self.correlation = correlation
        self.importance = importance
        self.timePeriod = timePeriod
        self.precedingData = precedingData
    }
    
}
