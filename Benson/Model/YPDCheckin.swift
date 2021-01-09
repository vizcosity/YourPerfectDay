//
//  File.swift
//  Benson
//
//  Created by Aaron Baw on 11/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import SwiftUI

/// A YPDCheckin object contains a collection of individual attribute values which the user has recorded for each given attribute type.
struct YPDCheckin: CustomStringConvertible, Identifiable {
    
    var description: String {
        get {
            return "\(self.attributeValues): \(self.timeSince)"
        }
    }
        
    /// Id for the Checkin.
    var id: String?
    var attributeValues: [YPDCheckinResponseValue] = []
    var timestamp: Date?
    var timeSince: String = "Some time ago"
    var startOfDay: Date?
    var endOfDay: Date?
    
    /// Summary data obtained from healthkit for the day when the log was recorded.
    #if MAIN_APP
    var enrichedData: BensonHealthDataObject?
    #endif
    
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
        #if MAIN_APP
        copiedMetric.enrichedData = self.enrichedData
        #endif
        
        return copiedMetric
    }
}

extension YPDCheckin: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case attributeValues = "attributes"
        case timestamp
        case timeSince = "timesince"
        case startOfDay
        case endOfDay
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.timestamp = Date.init(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .timestamp)))
        self.attributeValues = try container.decode([YPDCheckinResponseValue].self, forKey: .attributeValues)
        self.timeSince = (try? container.decode(String.self, forKey: .timeSince)) ?? timeSince
        self.startOfDay = try? container.decode(Date.self, forKey: .startOfDay)
        self.endOfDay = try? container.decode(Date.self, forKey: .endOfDay)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(timeSince, forKey: .timeSince)
        try container.encode(startOfDay, forKey: .startOfDay)
        try container.encode(endOfDay, forKey: .endOfDay)
    }
}
