//
//  Webserver.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 17/10/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

enum YPDEndpoint {
    
    // Change the API endpiont depending on whether we are running in the simulator or not.
    #if targetEnvironment(simulator)
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Local)"
    #else
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Heroku)"
    #endif
//    private static var infoAPIDictionaryKey = "Webserver Endpoint (Local Tunnel)"

    static let endpoint = Bundle.main.object(forInfoDictionaryKey: infoAPIDictionaryKey) as! String
//    static var endpoint = "http://e21936d414f8.ngrok.io/api/v1"
    
//    case getMetrics = "\(Webserver.endpoint)/metrics"
//    case getMetricLog = "\(Webserver.endpoint)/checkins"
//    case getLastCheckin = "\(Webserver.endpoint)/lastCheckin"
//    case submitCheckin = "\(Webserver.endpoint)/checkin"
//    case removeMetricLog = "\(Webserver.endpoint)/delete"
//    case submitHealthData = "\(Webserver.endpoint)/healthData"
//    case fetchUnenrichedCheckinDates = "\(Webserver.endpoint)/unenrichedCheckinDates"
//    case aggregatedCheckinsByCriteria = "\(Webserver.endpoint)/aggregatedCheckinsByCriteria"
//    case fetchInsights = "\(Webserver.endpoint)/analyse"

    case getMetrics
    case getMetricLog
    case getLastCheckin
    case submitCheckin
    case removeMetricLog
    case submitHealthData
    case fetchUnenrichedCheckinDates
    case aggregatedCheckins(criteria: AggregationCriteria)
    case aggregatedHealthDataAndCheckins(criteria: AggregationCriteria)
    case fetchInsights

//    static func aggregatedHealthDataAndCheckins(byCriteria criteria: String) -> String { return "\(Webserver.endpoint)/healthDataAndCheckinsAggregatedBy/\(criteria)" }

    var urlString: String {
        switch self {
        case .getMetrics: return "\(Self.endpoint)/metrics"
        case .getMetricLog: return "\(Self.endpoint)/checkins"
        case .getLastCheckin: return "\(Self.endpoint)/lastCheckin"
        case .submitCheckin: return "\(Self.endpoint)/checkin"
        case .removeMetricLog: return "\(Self.endpoint)/delete"
        case .submitHealthData: return "\(Self.endpoint)/healthData"
        case .fetchUnenrichedCheckinDates: return "\(Self.endpoint)/unenrichedCheckinDates"
        case .aggregatedCheckins(let criteria): return "\(Self.endpoint)/aggregatedCheckinsByCriteria/\(criteria.rawValue)"
        case .aggregatedHealthDataAndCheckins(let criteria): return "\(Self.endpoint)/healthDataAndCheckinsAggregatedBy/\(criteria.rawValue)"
        case .fetchInsights: return "\(Self.endpoint)/analyse"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }
        
}
