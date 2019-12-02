//
//  Fetcher.swift
//  Benson
//
//  Created by Aaron Baw on 26/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import Alamofire

struct Webserver {
    static var endpoint = Bundle.main.object(forInfoDictionaryKey: "Webserver Endpoint") as! String
    static var getMetrics: String = "\(Webserver.endpoint)/metrics"
    static var getMetricLog: String = "\(Webserver.endpoint)/checkins"
    static var getLastCheckin: String = "\(Webserver.endpoint)/lastCheckin"
    static var submitCheckin: String = "\(Webserver.endpoint)/checkin"
}

class Fetcher {
    
    var metricPrompts : [MetricPrompt] = []
    var metricLogs: [MetricLog] = []
    
    /// Fetches the title for the metric prompt given the Id. If no metric prompts are cached, the method fetches this as a pre-requisite. Defaults to the metric id passed if no metric prompt is found.
    public func getTitle(forMetricId metricId: String, completionHandler: @escaping (String) -> Void) {
        if metricPrompts.isEmpty {
            self.fetchAndCacheMetricPrompts(completionHandler: {
                _ in completionHandler(self.getTitleFromCachedMetricPrompts(forMetricId: metricId))
            })
        } else {
            completionHandler(self.getTitleFromCachedMetricPrompts(forMetricId: metricId))
        }
    }
    
    /// Fetches the title for the metric prompt given the Id. Defaults to the metric id passed if no metric prompt is found.
    private func getTitleFromCachedMetricPrompts(forMetricId metricId: String) -> String {
        return self.metricPrompts.filter { $0.metricId == metricId }.first?.metricTitle ?? metricId
    }
    
    private func fetchAndCacheMetricPrompts(completionHandler: @escaping ([MetricPrompt]) -> Void){
        self.fetchMetricPrompts(completionHandler: {
            self.metricPrompts = $0
            completionHandler($0)
        })
    }
        
    public func fetchMetricPrompts(completionHandler: @escaping ([MetricPrompt]) -> Void){
        
        print("[Fetcher] Fetching metric prompts from \(Webserver.getMetrics)")
        
        AF.request(Webserver.getMetrics).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            
            if let error = response.error {
                self.log("Error: \(error)")
            }
            
            self.log("Recieved resposne: \(response)")
                      if let metricPrompts = try? response.result.get() as? [[String: Any]] {
                        completionHandler(metricPrompts.map({ (metricPromptJSON) -> MetricPrompt in
                            return MetricPrompt.fromJSON(dict: metricPromptJSON)
                        }))
                      }
              }
    }
    
    
    // Checkpoint: Have just written a function to grab the metric titles given a metric id (this is not included in the metric log). Have since implemented this in the backend for simplicity.
    public func fetchMetricLogs(completionHandler: ([MetricLog]) -> Void) {
        
        AF.request(Webserver.getMetrics).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            self.log("Recieved metric logs: \(response)")
            
            if let metricLogsJSON = try? response.result.get() as? [[String: Any]] {
                self.log(metricLogsJSON)

                completionHandler(metricLogsJSON.map({ (metricLogJSON) -> MetricLog in

                    var metricAttributes : [MetricAttribute] = []

                    if let attributesFromResponse = metricLogJSON["attributes"] as? [[String : Any]] {
                        metricAttributes = attributesFromResponse.map({ (attribute) -> MetricAttribute in
                            // TODO: fetch the /name/ of the metric here, not just the ID.
                            return MetricAttribute(name: attribute["metricId"], value: attribute["value"])
                        })
                    }

                    MetricLog(metrics: metricAttributes, timeSince: "\(logResponse["timestamp"])")
                }))
            }

        }
    }
    
    private func log(_ message: String) {
        print("[Fetcher] | \(message)")
    }
    
}
