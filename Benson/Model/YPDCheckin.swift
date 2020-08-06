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
    
//    var id: String?
    
    /// Id for the Checkin.
    var id: String?
    var attributeValues: [YPDCheckinResponseValue] = []
    var timestamp: Date?
    var timeSince: String = "Some time ago"
    
    /// Summary data obtained from healthkit for the day when the log was recorded.
    var enrichedData: BensonHealthDataObject?
    
    init(attributeValues: [YPDCheckinResponseValue], timeSince: String, id: String? = nil){
        self.attributeValues = attributeValues
        self.timeSince = timeSince
        self.id = id
    }
    
    init(attributeValues: [YPDCheckinResponseValue], timeSince: String, timestamp: Int, id: String? = nil) {
        self.init(attributeValues: attributeValues, timeSince: timeSince)
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
        self.id = id
    }
    
    public func copy() -> YPDCheckin {
        var copiedMetric = YPDCheckin(attributeValues: self.attributeValues, timeSince: self.timeSince, id: self.id)
            
        copiedMetric.timestamp = self.timestamp
        copiedMetric.enrichedData = self.enrichedData
        
        return copiedMetric
    }
}

/// Ensure that Metric Logs are hashable so that we can use them in ForEach loops in SwiftUI.
extension YPDCheckin: Hashable {
    
    public func equals(otherMetricLog: YPDCheckin) -> Bool {
        return self.id == otherMetricLog.id &&
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
enum YPDCheckinType: String, CaseIterable, Hashable, Identifiable {
    
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
    
    var id: String {
        self.rawValue
    }
}
