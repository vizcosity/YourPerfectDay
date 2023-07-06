//
//  Fetcher.swift
//  Benson
//
//  Created by Aaron Baw on 26/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
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

    public func fetchMetricLogs() -> AnyPublisher<[YPDCheckin], YPDNetworkingError> {
        guard let url = YPDEndpoint.getMetricLog.url else { return Fail(error: YPDNetworkingError.generatingURLError).eraseToAnyPublisher() }
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryDecode(decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    public func fetchUnenrichedCheckinDates() -> AnyPublisher<[Date], YPDNetworkingError> {
        guard let url = YPDEndpoint.fetchUnenrichedCheckinDates.url else { return Fail(error: YPDNetworkingError.generatingURLError).eraseToAnyPublisher() }
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode)
                }
                print("Fetching unenriched checkin dates: \(String.init(data: data, encoding: .utf8) ?? "Unable to decode")")
                return data
            }
            .decode(type: YPDUnenrichedCheckinDatesResponse.self, decoder: JSONDecoder.withYPDDateDecoding)
            .print()
            .map(\.dates)
            .mapError(YPDNetworkingError.mapError(_:))
            .eraseToAnyPublisher()
    }
    
    // MARK: Fetching checkin data
    /// Fetches aggregated healthData objects, as well as aggregated checkin objects, merging each object for the same date and returning an array of results.
    public func fetchAggregatedHealthAndCheckinData(byAggregationCriteria criteria: AggregationCriteria) -> AnyPublisher<YPDAggregatedHealthAndCheckinDataResponse, YPDNetworkingError> {
        guard let url = YPDEndpoint.aggregatedHealthDataAndCheckins(criteria: criteria).url else { return Fail(error: YPDNetworkingError.generatingURLError).eraseToAnyPublisher() }
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { response in
                guard let httpResponse = response.response as? HTTPURLResponse else { throw YPDNetworkingError.castingError }
                guard httpResponse.statusCode == 200 else { throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode) }
                return response.data
            }
            .decode(type: YPDAggregatedHealthAndCheckinDataResponse.self, decoder: JSONDecoder.withYPDDateDecoding)
            .mapError(YPDNetworkingError.mapError(_:))
            .eraseToAnyPublisher()
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
//    public func submitHealthDataObject(healthDataObject: BensonHealthDataObject, completionHandler: @escaping (_ id: String?, _ error: String?) -> Void){
//        self.sendPostRequest(toEndpoint: YPDEndpoint.submitHealthData, withStringBody: healthDataObject.toJSONString() ?? "{}") { (json) in
//            if let success = Bool(json["success"].stringValue), success {
//                completionHandler(json["id"].stringValue, nil)
//            } else {
//                completionHandler(nil, json["reason"].stringValue)
//            }
//        }
//
////        self.post(to: YPDEndpoint.submitHealthData, with: healthDataObject)
//    }
//
//    /// Submits multiple health data objects to the backend.
//    public func submitHealthDataObjects(healthDataObjects: [BensonHealthDataObject], completionHandler: @escaping (_ id: String?, _ error: String?) -> Void){
//
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//
//        let stringifiedHealthDataObjects = try? encoder.encode(healthDataObjects)
//
//        guard let unwrappedStringifiedHealthDataObjects = stringifiedHealthDataObjects else { return completionHandler(nil, "Could not unwrap stringifiedHealthDataObjects optional. Debug encoder.") }
//
//        let body = NSString(data: unwrappedStringifiedHealthDataObjects, encoding: String.Encoding.utf8.rawValue)!
//
//        self.log("Encoded array of health data objects: \(String(describing: body)). Attempting to submit now.")
//
//        self.sendPostRequest(toEndpoint: YPDEndpoint.submitHealthData, withStringBody: String(body)) { (json) in
//             if let success = Bool(json["success"].stringValue), success {
//                  completionHandler(json["id"].stringValue, nil)
//              } else {
//                  completionHandler(nil, json["reason"].stringValue)
//              }
//        }
//    }

    public func submit(healthDataObject: BensonHealthDataObject) -> AnyPublisher<YPDHealthDataSubmissionResponse, YPDNetworkingError> {
        log("Submitting health data object: \(healthDataObject).")
        return post(to: .submitHealthData, with: healthDataObject)
    }
    
    public func submit(healthDataObjects: [BensonHealthDataObject]) -> AnyPublisher<YPDHealthDataSubmissionResponse, YPDNetworkingError> {
        log("Submitting \(healthDataObjects.count) health data objects.")
        return post(to: .submitHealthData, with: healthDataObjects)
    }

    public func submit(checkins: [YPDCheckinPrompt]) -> AnyPublisher<YPDCheckinPromptSubmissionResponse, YPDNetworkingError> {
        let submissionBody = [
            "array": checkins.map {
                [
                    "metricId": $0.responseValue.type.rawValue,
                    "value": $0.responseValue.value + 1
                ]
            }
        ]
        return post(to: .submitCheckin, with: submissionBody)
    }
    
    public func remove(checkin: YPDCheckin) -> AnyPublisher<YPDCheckinRemovalResponse, YPDNetworkingError> {
        guard let metricId = checkin.id else { return Fail(error: YPDNetworkingError.castingError).eraseToAnyPublisher() }
        return post(to: .removeMetricLog, with: ["metricId": metricId])
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
        
//    private func sendPostRequest(toEndpoint endpoint: YPDEndpoint, withBody bodyDict: [String: String], completionHandler: @escaping (JSON) -> Void){
//        let encoder = JSONEncoder()
//        let bodyJSONData = try? encoder.encode(bodyDict)
//        let bodyJSONSerialised = NSString(data: bodyJSONData!, encoding: String.Encoding.utf8.rawValue)
//        self.sendPostRequest(toEndpoint: endpoint, withStringBody: String(bodyJSONSerialised!), completionHandler: completionHandler)
//    }
//
//    private func sendPostRequest(toEndpoint endpoint: YPDEndpoint, withStringBody body: String, completionHandler: @escaping (JSON) -> Void){
//        var request = URLRequest(url: endpoint.url!)
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let bodyJSONSerialised = NSString(string: body)
//        request.httpBody = bodyJSONSerialised.data(using: String.Encoding.utf8.rawValue)
//
//        AF.request(request).responseJSON(queue: DispatchQueue.global(qos: .userInitiated), options: .allowFragments) { (response) in
//
//            switch response.result {
//                // It seems like each case statement places the value associated with the response into the parameter which can be assigned to a variable?
//                case .success(let value):
//                    return completionHandler(JSON(value))
//                case .failure(let error):
//                    self.log("Failed to submit post request to \(endpoint), received error \(error)")
//                }
//        }
//
//    }

    private func post<T: Decodable, B>(to endpoint: YPDEndpoint, with body: B) -> AnyPublisher<T, YPDNetworkingError> {
        guard
            let url = endpoint.url,
            let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [.fragmentsAllowed, .prettyPrinted])
        else { return Fail(error: YPDNetworkingError.generatingURLError).eraseToAnyPublisher() }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession
            .shared
            .dataTaskPublisher(for: urlRequest)
            .tryDecode(type: T.self, decoder: JSONDecoder.withYPDDateDecoding)
            .eraseToAnyPublisher()
    }
    
//    private func sendGetRequest(toEndpoint endpoint: String, withQuery query: String?, completionHandler: @escaping (JSON) -> Void){
//        AF.request(endpoint + (query != nil ? "?\(query!)" : "")).responseJSON(queue: DispatchQueue.global(qos: .background), options: .allowFragments) { (response) in
//            switch response.result {
//            case .success(let data):
//                // Ensure that we call the completionHandler on the main thread, as we will likely be updating the UI.
//                DispatchQueue.main.async {
//                    return completionHandler(JSON(data))
//                }
//            case .failure(let error):
//                return self.log("Error performing GET request for endpoint \(endpoint) with query: \(String(describing: query)). Error: \(error)")
//            }
//        }
//    }
//
    private func log(_ message: String) {
        print("[Fetcher] | \(message)")
    }
    
}

/// Fetching insights and other analysis-related data.
extension Fetcher {

    public func fetchInsights(forMetric metric: YPDCheckinType = .vitality, withAggregationCriteria aggregationCriteria: AggregationCriteria, limit: Int? = nil) -> AnyPublisher<[YPDInsight], YPDNetworkingError> {
        
        var body = [
            "aggregationCriteria": aggregationCriteria.description,
            "desiredMetric": metric.rawValue
        ]
        
        if let limit = limit {
            body["limit"] = "\(limit)"
        }
        
        let response: AnyPublisher<YPDInsightResponse, YPDNetworkingError> = post(to: .fetchInsights, with: body)
        return response
            .map(\.data)
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}

