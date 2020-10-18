//
//  YPDCheckinResponseValue.swift
//  Benson
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

/// Contains the value for a single attribute (e.g., `Mood`, `Energy`, etc) within a YPD Checkin.
struct YPDCheckinResponseValue: Decodable {
    
    var value: Double
    var average: Double?
    var type: YPDCheckinType
    
    /// The maximum value which can be observed or recorded for the given metric.
    var maxValue: Double = 5
    
    /// Initialises an empty, unsubmitted YPDCheckinAttributeValue option based off of the accompanied response option. This will be populated once the user records their response value.
    init(selectedResponseOption: YPDCheckinResponseOption) {
        // self.readableTitle = selectedResponseOption.readableTitle
        self.type = selectedResponseOption.type ?? .unknown
        self.value = 0
    }
    
    init(type: YPDCheckinType, value: Double, average: Double? = nil){
        // self.readableTitle = readableTitle
        self.average = average ?? value
        self.type = type
        self.value = value
    }
    
    init(type: String, value: Double, average: Double? = nil){
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
//extension YPDCheckinResponseValue: Hashable {
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(ObjectIdentifier(self))
//    }
//    
//}

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

/// Describes the different options a user can select for an individual checkin prompt attribute.
/// Example:
///     I'm Feeling:
///         "Horrible" (0), "Meh" (1), "Okay" (2), "Not Bad" (3), "Great" (4)
struct YPDCheckinResponseOption: Codable {
    
    /// The parent type which the response option belongs to.
    var type: YPDCheckinType?
    
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
    
    enum CodingKeys: String, CodingKey {
        case label = "title", value
    }
    
}

