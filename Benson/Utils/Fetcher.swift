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
import Combine

class Fetcher {
    
    var healthManager: BensonHealthManager = BensonHealthManager()!
    var metricPrompts : [YPDCheckinPrompt] = []
    var metricLogs: [YPDCheckin] = []
    
    static let sharedInstance = Fetcher()
    
    /// Fetches the title for the metric prompt given the Id. Defaults to the metric id passed if no metric prompt is found.
    private func getTitleFromCachedMetricPrompts(forMetricId metricId: String) -> String {
        return self.metricPrompts.filter { $0.type == metricId }.first?.readableTitle ?? metricId
    }
    
    // MARK: - Fetching YPD CheckinPrompts
    
    /// Combine method for fetching metric prompts.
    public func fetchMetricPrompts() -> AnyPublisher<[YPDCheckinPrompt], YPDNetworkingError> {
        let url = YPDEndpoint.getMetrics.url!
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }.decode(type: [YPDCheckinPrompt].self, decoder: JSONDecoder())
            .mapError(YPDNetworkingError.mapError(_:))
            .eraseToAnyPublisher()
    }
    
    
    // Checkpoint: Have just written a function to grab the metric titles given a metric id (this is not included in the metric log). Have since implemented this in the backend for simplicity.
    public func fetchMetricLogs(completionHandler: @escaping ([YPDCheckin]) -> Void) {
        
        AF.request(YPDEndpoint.getMetricLog.urlString).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            
            if let checkinJSON = try? response.result.get() as? [[String: Any]] {

                // Map each JSON object ot the MetricLog object and return this as part of the completionHandler.
                let checkins = checkinJSON.map({ (metricLogJSON) -> YPDCheckin in

                    var attributeValues : [YPDCheckinResponseValue] = []

                    if let attributesFromResponse = metricLogJSON["attributes"] as? [[String : Any]] {
                        attributeValues = attributesFromResponse.map({ (attribute) -> YPDCheckinResponseValue in
                            return YPDCheckinResponseValue(type: attribute["metricId"] as? String ?? "", value: attribute["value"] as? Double ?? 0)
                        })
                    }

                    // Checkpoint: attaching a Date to each metric log to know when to grab HealthKit data for enrichment.
                    return YPDCheckin(attributeValues: attributeValues, timeSince: metricLogJSON["timesince"] as? String ?? "Some time ago", timestamp: metricLogJSON["timestamp"] as? Int ?? 0, id: metricLogJSON["_id"] as? String)
                })
                
                // Run the comletionHandler within the main thread as the argument passed to the completion handler will most likely be used to update the UI.
                DispatchQueue.main.async {
                    return completionHandler(checkins)
                }
            }
        }
    }
    
    /// Fetches dates for all unenricehd checkins.
    public func fetchUnenrichedCheckinDates(completionHandler: @escaping ([Date]) -> Void) {
        AF.request(YPDEndpoint.fetchUnenrichedCheckinDates.url!).responseJSON(queue: DispatchQueue.global(qos: .background), options: .allowFragments) { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let success = Bool(json["success"].stringValue), success {
                        let dates = json["result"].arrayValue.map({ (unenrichedCheckinInfo) -> Date? in
                            
                            // Parse the dates from ISO format.
                            let formatter = ISO8601DateFormatter()
                            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                            let parsedDate = formatter.date(from: unenrichedCheckinInfo.stringValue)
                            self.log("Attempting to parse \(unenrichedCheckinInfo.stringValue) as a date: \(String(describing: parsedDate))")
                            return parsedDate
                        })
                        
                        let unwrappedDates = dates.filter { $0 != nil }.map { $0! }
                        
                        return completionHandler(unwrappedDates)
                    }
                    
                case .failure(let error):
                    self.log("Error retrieving unenriched checkins: \(error)")
            }
            
        }
    }
    
    // MARK: Fetching checkin data
    
    /// Fetches aggregated healthData objects, as well as aggregated checkin objects, merging each object for the same date and returning an array of results.
    public func fetchAggregatedHealthAndCheckinData(byAggregationCriteria criteria: AggregationCriteria, completionHandler: @escaping(JSON) -> Void){
        self.sendGetRequest(toEndpoint: YPDEndpoint.aggregatedHealthDataAndCheckins(criteria: criteria).urlString, withQuery: nil, completionHandler: completionHandler)
    }

    public func fetchAggregateData(byAggregationCriteria criteria: AggregationCriteria) -> AnyPublisher<[YPDAggregate], YPDNetworkingError> {
        URLSession
            .shared
            .dataTaskPublisher(for: YPDEndpoint.aggregatedHealthDataAndCheckins(criteria: criteria).url!)
            .tryMap { response in
                guard let httpResponse = response.response as? HTTPURLResponse else { throw YPDNetworkingError.castingError }
                guard httpResponse.statusCode == 200 else { throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode) }
                return response.data
            }
            .decode(type: YPDAggregateResponse.self, decoder: JSONDecoder())
            .map { $0.result }
            .mapError(YPDNetworkingError.mapError(_:))
            .eraseToAnyPublisher()
    }
    
    // MARK: - Submitting Health Data
    
    /// Submits a health data object to the backend.
    /// The completionHandler receives the ID for the submitted healthdata object, if submitted successfully.
    public func submitHealthDataObject(healthDataObject: BensonHealthDataObject, completionHandler: @escaping (_ id: String?, _ error: String?) -> Void){
        self.sendPostRequest(toEndpoint: YPDEndpoint.submitHealthData, withStringBody: healthDataObject.toJSONString() ?? "{}") { (json) in
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
        
        let stringifiedHealthDataObjects = try? encoder.encode(healthDataObjects)
        
        guard let unwrappedStringifiedHealthDataObjects = stringifiedHealthDataObjects else { return completionHandler(nil, "Could not unwrap stringifiedHealthDataObjects optional. Debug encoder.") }
        
        let body = NSString(data: unwrappedStringifiedHealthDataObjects, encoding: String.Encoding.utf8.rawValue)!
        
        self.log("Encoded array of health data objects: \(String(describing: body)). Attempting to submit now.")

        self.sendPostRequest(toEndpoint: YPDEndpoint.submitHealthData, withStringBody: String(body)) { (json) in
             if let success = Bool(json["success"].stringValue), success {
                  completionHandler(json["id"].stringValue, nil)
              } else {
                  completionHandler(nil, json["reason"].stringValue)
              }
        }
    }
    
    
    /// Submits an array of YPDCheckinPrompts which have had their ResponesValues selected by the user.
    // TODO: Ensure that this makes use of Combine asynchronous data affordances, such as Future, Just, and so on.
    public func submitCheckin(checkinPrompts: [YPDCheckinPrompt], completionHandler: @escaping (Bool) -> Void){

        let responseValueArray: [[String: Any]] = checkinPrompts.map {
            [
                "metricId": $0.responseValue.type.rawValue,
                "value": $0.responseValue.value + 1
            ] as [String : Any]
        }

        self.log("Generated response value array: \(responseValueArray)")

        AF.request(YPDEndpoint.submitCheckin.url!, method: .post, parameters: [
                "array": responseValueArray
            ],
                   encoding: JSONEncoding.default).responseJSON { (response) in
                    do {
                        if let result = try response.result.get() as? [String:Any] {
                                return completionHandler(result["success"] as? Int == 1)
                        }
                    } catch {
                        self.log("Could not submit checkins: \(error.localizedDescription)")

                        return completionHandler(false)
                    }
        }
    }
    
    public func submitCheckinAsString(checkinPrompts: [YPDCheckinPrompt], completionHandler: @escaping (Bool) -> Void){
        let responseValueArray: [[String: Any]] = checkinPrompts.map {
            [
                "metricId": $0.responseValue.type.rawValue,
                "value": $0.responseValue.value
                ] as [String : Any]
        }
        
        let postBody = JSON(["array": responseValueArray]).stringValue
        
        self.log("Submitting \(postBody)")
                
        self.sendPostRequest(toEndpoint: YPDEndpoint.submitCheckin, withStringBody: postBody) { (response) in
            self.log("Submitted checkin with response: \(response.stringValue)")
        }
        
    }

    // Checkpoint: Implementing swipe to delete checkin functionality.
    public func remove(metricLogId: String, completionHandler: @escaping () -> Void) {
        
        var request = URLRequest(url: YPDEndpoint.removeMetricLog.url!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyDict: [String: String] = ["metricId": metricLogId]
        let encoder = JSONEncoder()
        let bodyJSONData = try? encoder.encode(bodyDict)
        let bodyJSONSerialised = NSString(data: bodyJSONData!, encoding: String.Encoding.utf8.rawValue)

        request.httpBody = bodyJSONSerialised!.data(using: String.Encoding.utf8.rawValue)
        
        AF.request(request).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
            // self.log(response.debugDescription)
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
    public func enrichMetricLogWithHealthKitData(forMetricLog metricLog: YPDCheckin, completionHandler: @escaping (YPDCheckin) -> Void) {
        
        // Instantiate a date object for the metricLog.
        guard let date = metricLog.timestamp else {
            return self.log("Could not obtain date for metric log \(metricLog.id ?? metricLog.description)")
        }
        
        self.healthManager.fetchHealthData(forDay: date){ healthDataObject in
            // metricLog.enrichedData = healthDataObject
            
            var metricLogCopy = metricLog.copy()
            metricLogCopy.enrichedData = healthDataObject
            
            return completionHandler(metricLogCopy)
        }
        
    }
        
    private func sendPostRequest(toEndpoint endpoint: YPDEndpoint, withBody bodyDict: [String: String], completionHandler: @escaping (JSON) -> Void){
        let encoder = JSONEncoder()
        let bodyJSONData = try? encoder.encode(bodyDict)
        let bodyJSONSerialised = NSString(data: bodyJSONData!, encoding: String.Encoding.utf8.rawValue)
        self.sendPostRequest(toEndpoint: endpoint, withStringBody: String(bodyJSONSerialised!), completionHandler: completionHandler)
    }
     
    private func sendPostRequest(toEndpoint endpoint: YPDEndpoint, withStringBody body: String, completionHandler: @escaping (JSON) -> Void){
        var request = URLRequest(url: endpoint.url!)
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
    
    private func sendGetRequest(toEndpoint endpoint: String, withQuery query: String?, completionHandler: @escaping (JSON) -> Void){
        AF.request(endpoint + (query != nil ? "?\(query!)" : "")).responseJSON(queue: DispatchQueue.global(qos: .background), options: .allowFragments) { (response) in
            switch response.result {
            case .success(let data):
                // Ensure that we call the completionHandler on the main thread, as we will likely be updating the UI.
                DispatchQueue.main.async {
                    return completionHandler(JSON(data))
                }
            case .failure(let error):
                return self.log("Error performing GET request for endpoint \(endpoint) with query: \(String(describing: query)). Error: \(error)")
            }
        }
    }
    
    private func log(_ message: String) {
        print("[Fetcher] | \(message)")
    }
    
}

/// Fetching insights and other analysis-related data.
extension Fetcher {
    public func fetchInsights(forMetric metric: YPDCheckinType = .vitality, withAggregationCriteria aggregationCriteria: AggregationCriteria, limit: Int? = nil, completionHandler: @escaping ([YPDInsight]) -> Void) {
        
        var body = [
            "aggregationCriteria": aggregationCriteria.description,
            "desiredMetric": metric.rawValue
        ]
        
        if let limit = limit {
            body["limit"] = "\(limit)"
        }
        
        self.sendPostRequest(toEndpoint: YPDEndpoint.fetchInsights, withBody: body) { (json) in
            // TODO: Parse JSON response as YPD Insights.
            // TODO: Alter YPD Insights to conform to better support an entire insight with multiple important metrics.
            completionHandler(json["data"].arrayValue.map(YPDInsight.init(json:)))
        }
    }
}

