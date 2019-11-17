//
//  File.swift
//  Benson
//
//  Created by Aaron Baw on 11/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation

// Data model for a single attribute.
class MetricAttribute {
    static let maxValue = 5
    var name: String
    var value: Int
    var average: Int?
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}

// Data model for metric logs.
class MetricLog {
        
    var metrics: [MetricAttribute]?
    var timeSince: String?
    
    // TODO: Add convenience initialiser which can take in a JSON object.
    init() {
        self.timeSince = "Some time ago"
    }
    
    init(metrics: [MetricAttribute], timeSince: String){
        self.metrics = metrics
        self.timeSince = timeSince
    }
    
}
