//
//  File.swift
//  Benson
//
//  Created by Aaron Baw on 11/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation

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
                    var metricResponse = MetricResponse(title: "", value: 0)
                if let title = responseJSON["title"] as? String, let value = responseJSON["value"] as? Int {
                        metricResponse = MetricResponse(title: title, value: value)
                    }
                    return metricResponse
            // Filter out metric responses where we fail to unwrap the title and value optionals.
            }).filter { $0.title != "" }
         metricId = metricIdJSON
         metricTitle = metricTitleJSON
        }
        
        return MetricPrompt(metricId: metricId, metricTitle: metricTitle, responses: responses)
    }
}

/// Describes the different options a user can select for a given metric prompt.
class MetricResponse {
    var title: String
    var value: Int
    init(title: String, value: Int) {
        self.title = title
        self.value = value
    }
}

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
    var timestamp: Date?
    var timeSince: String?
    
    // TODO: Add convenience initialiser which can take in a JSON object.
    init() {
        self.timeSince = "Some time ago"
    }
    
    init(metrics: [MetricAttribute], timeSince: String){
        self.metrics = metrics
        self.timeSince = timeSince
    }
    
    convenience init(metrics: [MetricAttribute], timeSince: String, timestamp: Int) {
        self.init(metrics: metrics, timeSince: timeSince)
        self.timestamp = Date(timeIntervalSince1970: Double(timestamp))
    }
    
}
