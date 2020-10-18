//
//  Webserver.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 17/10/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

enum Webserver {
    
    // Change the API endpiont depending on whether we are running in the simulator or not.
    #if targetEnvironment(simulator)
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Local)"
    #else
        private static var infoAPIDictionaryKey = "Webserver Endpoint (Heroku)"
    #endif
//    private static var infoAPIDictionaryKey = "Webserver Endpoint (Local Tunnel)"

    static var endpoint = Bundle.main.object(forInfoDictionaryKey: infoAPIDictionaryKey) as! String
//    static var endpoint = "http://e21936d414f8.ngrok.io/api/v1"
    static var getMetrics: String = "\(Webserver.endpoint)/metrics"
    static var getMetricLog: String = "\(Webserver.endpoint)/checkins"
    static var getLastCheckin: String = "\(Webserver.endpoint)/lastCheckin"
    static var submitCheckin: String = "\(Webserver.endpoint)/checkin"
    static var removeMetricLog: String = "\(Webserver.endpoint)/delete"
    static var submitHealthData: String = "\(Webserver.endpoint)/healthData"
    static var fetchUnenrichedCheckinDates: String = "\(Webserver.endpoint)/unenrichedCheckinDates"
    static var aggregatedCheckinsByCriteria: String = "\(Webserver.endpoint)/aggregatedCheckinsByCriteria"
    static var fetchInsights: String = "\(Webserver.endpoint)/analyse"
    static func aggregatedHealthDataAndCheckins(byCriteria criteria: String) -> String { return "\(Webserver.endpoint)/healthDataAndCheckinsAggregatedBy/\(criteria)" }
        
}
