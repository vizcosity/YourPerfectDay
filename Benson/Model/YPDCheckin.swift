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
struct YPDCheckin: CustomStringConvertible, Identifiable, Decodable {
    
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
