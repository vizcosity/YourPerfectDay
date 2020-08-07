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
