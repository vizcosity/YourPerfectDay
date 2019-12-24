//
//  Fetcher.swift
//  Benson
//
//  Created by Aaron Baw on 26/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
//import Alamofire_S

struct Webserver {
    
    // Change the API endpiont depending on whether we are running in the simulator or not.
    #if targetEnvironment(simulator)
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Local)"
    #else
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Heroku)"
    #endif

    static var endpoint = Bundle.main.object(forInfoDictionaryKey: infoAPIDictionaryKey) as! String
    static var getMetrics: String = "\(Webserver.endpoint)/metrics"
    static var getMetricLog: String = "\(Webserver.endpoint)/checkins"
    static var getLastCheckin: String = "\(Webserver.endpoint)/lastCheckin"
    static var submitCheckin: String = "\(Webserver.endpoint)/checkin"
    static var removeMetricLog: String = "\(Webserver.endpoint)/delete"
    static var submitHealthData: String = "\(Webserver.endpoint)/healthData"
    static var fetchUnenrichedCheckinDates: String = "\(Webserver.endpoint)/unenrichedCheckinDates"
    static var aggregatedCheckinsByCriteria: String = "\(Webserver.endpoint)/aggregatedCheckinsByCriteria"
    
}

class Fetcher {
    
    var healthManager: BensonHealthManager = BensonHealthManager()!
    var metricPrompts : [MetricPrompt] = []
    var metricLogs: [MetricLog] = []
    
    static let sharedInstance = Fetcher()
    
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
            
//            self.log("Recieved resposne: \(response)")
                      if let metricPrompts = try? response.result.get() as? [[String: Any]] {
                        completionHandler(metricPrompts.map({ (metricPromptJSON) -> MetricPrompt in
                            return MetricPrompt.fromJSON(dict: metricPromptJSON)
                        }))
                      }
              }
    }
    
    
    // Checkpoint: Have just written a function to grab the metric titles given a metric id (this is not included in the metric log). Have since implemented this in the backend for simplicity.
    public func fetchMetricLogs(completionHandler: @escaping ([MetricLog]) -> Void) {
        
        AF.request(Webserver.getMetricLog).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
//            self.log("Recieved metric logs: \(response)")
            
            if let metricLogsJSON = try? response.result.get() as? [[String: Any]] {
                self.log("\(metricLogsJSON)")

                // Map each JSON object ot the MetricLog object and return this as part of the completionHandler.
                let metricLogs = metricLogsJSON.map({ (metricLogJSON) -> MetricLog in

                    var metricAttributes : [MetricAttribute] = []

                    if let attributesFromResponse = metricLogJSON["attributes"] as? [[String : Any]] {
                        metricAttributes = attributesFromResponse.map({ (attribute) -> MetricAttribute in
                            return MetricAttribute(name: attribute["title"] as? String ?? "Attribute", value: attribute["value"] as? Int ?? 0)
                        })
                    }

                    // Checkpoint: attaching a Date to each metric log to know when to grab HealthKit data for enrichment.
                    return MetricLog(metrics: metricAttributes, timeSince: metricLogJSON["timesince"] as? String ?? "Some time ago", timestamp: metricLogJSON["timestamp"] as? Int ?? 0, id: metricLogJSON["_id"] as? String)
                })
                
                // Run the comletionHandler within the main thread as the argument passed to the completion handler will most likely be used to update the UI.
                DispatchQueue.main.async {
                    return completionHandler(metricLogs)
                }
            }
        }
    }
    
    /// Fetches dates for all unenricehd checkins.
    public func fetchUnenrichedCheckinDates(completionHandler: @escaping ([Date]) -> Void) {
        AF.request(Webserver.fetchUnenrichedCheckinDates).responseJSON(queue: DispatchQueue.global(qos: .background), options: .allowFragments) { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let success = Bool(json["success"].stringValue), success {
                        let dates = json["result"].arrayValue.map({ (unenrichedCheckinInfo) -> Date? in
                            
                            // Parse the dates from ISO format.
                            let formatter = ISO8601DateFormatter()
                            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            let parsedDate = formatter.date(from: unenrichedCheckinInfo["startOfDay"].stringValue)
//                            self.log("Attempting to parse \(unenrichedCheckinInfo["startOfDay"].stringValue) as a date: \(String(describing: parsedDate))")
                            return formatter.date(from: unenrichedCheckinInfo["startOfDay"].stringValue)
                        })
                        
                        let unwrappedDates = dates.filter { $0 != nil }.map { $0! }
                        
                        return completionHandler(unwrappedDates)
                    }
                    
                case .failure(let error):
                    self.log("Error retrieving unenriched checkins: \(error)")
            }
            
        }
    }
    
    /// Submits a health data object to the backend.
    /// The completionHandler receives the ID for the submitted healthdata object, if submitted successfully.
    public func submitHealthDataObject(healthDataObject: BensonHealthDataObject, completionHandler: @escaping (_ id: String?, _ error: String?) -> Void){
        self.sendPostRequest(toEndpoint: Webserver.submitHealthData, withStringBody: healthDataObject.toJSONString() ?? "{}") { (json) in
            if let success = Bool(json["success"].stringValue), success {
                completionHandler(json["id"].stringValue, nil)
            } else {
                completionHandler(nil, json["reason"].stringValue)
            }
        
        }
    }
    
    /// Submits multiple health data objects to the backend.
    public func submitHealthDataObjects(healthDataObjects: [BensonHealthDataObject], completionHandler: @escaping (_ id: String?, _ error: String?) -> Void){
                
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
//        let stringifiedHealthDataObjects = try? encoder.encode(healthDataObjects.map { (healthDataObject) -> String in
//            return healthDataObject.toJSONString() ?? "{}"
//        })
        
        let stringifiedHealthDataObjects = try? encoder.encode(healthDataObjects)
        
        guard let unwrappedStringifiedHealthDataObjects = stringifiedHealthDataObjects else { return completionHandler(nil, "Could not unwrap stringifiedHealthDataObjects optional. Debug encoder.") }
        
        let body = NSString(data: unwrappedStringifiedHealthDataObjects, encoding: String.Encoding.utf8.rawValue)!
        
        self.log("Encoded array of health data objects: \(String(describing: body)). Attempting to submit now.")

        self.sendPostRequest(toEndpoint: Webserver.submitHealthData, withStringBody: String(body)) { (json) in
             if let success = Bool(json["success"].stringValue), success {
                  completionHandler(json["id"].stringValue, nil)
              } else {
                  completionHandler(nil, json["reason"].stringValue)
              }
        }
    }
    
    // Checkpoint: Implementing swipe to delete checkin functionality.
    public func remove(metricLogId: String, completionHandler: @escaping () -> Void) {
        
        var request = URLRequest(url: URL(string: Webserver.removeMetricLog)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyDict: [String: String] = ["metricId": metricLogId]
        let encoder = JSONEncoder()
        let bodyJSONData = try? encoder.encode(bodyDict)
        let bodyJSONSerialised = NSString(data: bodyJSONData!, encoding: String.Encoding.utf8.rawValue)

        request.httpBody = bodyJSONSerialised!.data(using: String.Encoding.utf8.rawValue)
        
        AF.request(request).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            self.log(response.debugDescription)
            let result = response.value as? [String: Bool]
            if result?["success"] ?? false {
                self.log("Removed \(metricLogId)")
            } else {
                self.log("Failed to remove \(metricLogId)")
            }
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    /// Given a metric log, fetches the BensonHealthKitDataObject associated with the given date which the log took place. To start with, Benson will fetch all metric logs for the user, and identify any logs which have not been enriched, by using the date from the timestamp and searching for all health data within this range.
    //TODO: Implement a background job to search for unenriched metric logs and to enrich them.
    public func enrichMetricLogWithHealthKitData(forMetricLog metricLog: MetricLog, completionHandler: @escaping (MetricLog) -> Void) {
        
        // Instantiate a date object for the metricLog.
        guard let date = metricLog.timestamp else {
            return self.log("Could not obtain date for metric log \(metricLog.id ?? metricLog.description)")
        }
        
        self.healthManager.fetchHealthData(forDay: date){ healthDataObject in
            metricLog.enrichedData = healthDataObject
            return completionHandler(metricLog)
        }
        
    }
        
    private func sendPostRequest(toEndpoint endpoint: String, withBody bodyDict: [String: String], completionHandler: @escaping (JSON) -> Void){
        let encoder = JSONEncoder()
        let bodyJSONData = try? encoder.encode(bodyDict)
        let bodyJSONSerialised = NSString(data: bodyJSONData!, encoding: String.Encoding.utf8.rawValue)
        self.sendPostRequest(toEndpoint: endpoint, withStringBody: String(bodyJSONSerialised!), completionHandler: completionHandler)
    }
     
    private func sendPostRequest(toEndpoint endpoint: String, withStringBody body: String, completionHandler: @escaping (JSON) -> Void){
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyJSONSerialised = NSString(string: body)
        request.httpBody = bodyJSONSerialised.data(using: String.Encoding.utf8.rawValue)
        
        AF.request(request).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            
            switch response.result {
                // It seems like each case statement places the value associated with the response into the parameter which can be assigned to a variable?
                case .success(let value):
                    return completionHandler(JSON(value))
                case .failure(let error):
                    self.log("Failed to submit post request to \(endpoint), received error \(error)")
                }
        }
        
    }
    
    private func log(_ message: String) {
        print("[Fetcher] | \(message)")
    }
    
}
