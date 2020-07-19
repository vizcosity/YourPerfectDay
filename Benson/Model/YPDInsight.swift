//
//  YPDInsight.swift
//  Benson
//
//  Created by Aaron Baw on 11/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON


// EXAMPLE YPD Anomaly response from API:
//{
//    "desired_metric": "vitality",
//    "anomaly_index": 2,
//    "anomaly_value": 4,
//    "anomaly_metrics": {
//        "correlation": 1,
//        "local_percentage_change": 0.8606060606060608,
//        "local_mean": 3.1607142857142856,
//        "global_percentage_change": 0.100217378490425,
//        "global_mean": 2.872808908045977
//    },
//    "anomaly_start_of_date": "2020-06-24T00:00:00.000Z",
//    "preceding_data": {
//        "startOfDate": [
//            "2020-06-24T00:00:00.000Z",
//            "2020-06-22T00:00:00.000Z",
//            "2020-06-21T00:00:00.000Z",
//            "2020-06-09T00:00:00.000Z",
//            "2020-06-08T00:00:00.000Z",
//            "2020-06-04T00:00:00.000Z",
//            "2020-05-31T00:00:00.000Z"
//        ],
//        "activeEnergyBurned": [
//            265.06000000000006,
//            376.7889999999986,
//            513.0229999999899,
//            829.3399999999991,
//            590.7119999999884,
//            635.640999999996,
//            560.609999999982
//        ],
//        "basalEnergyBurned": [
//            1582.1530000000005,
//            1577.5120000000165,
//            1573.9580000000585,
//            1608.338999999996,
//            1366.8410000000229,
//            1676.3500000000147,
//            1119.0550000000235
//        ],
//        "caloricIntake": [
//            1888.4634246826172,
//            1837.265697479248,
//            854.8002319335938,
//            1643.7638244628906,
//            873.8393249511719,
//            883.6720123291016,
//            604.7999877929688
//        ],
//        "dietaryCarbohydrates": [
//            143.51368236541748,
//            190.30103492736816,
//            110.49192810058594,
//            127.2767574340105,
//            92.45075798034668,
//            48.61190986633301,
//            67.1050033569336
//        ],
//        "dietaryFats": [
//            80.5267858505249,
//            67.88369965553284,
//            9.083971977233887,
//            58.775335885584354,
//            22.818938732147217,
//            22.84429109096527,
//            25.11750030517578
//        ],
//        "dietaryProtein": [
//            143.0988302230835,
//            134.7524688243866,
//            74.5744857788086,
//            153.88283443450928,
//            72.62894439697266,
//            118.38497161865234,
//            26.575000762939453
//        ],
//        "hrv": [
//            56.054286411830354,
//            57.31756146748861,
//            66.1868109703064,
//            56.5038800239563,
//            42.29812971750895,
//            53.66749978065491,
//            57.22919591267904
//        ],
//        "lowHeartRateEvents": [
//            18,
//            5,
//            1,
//            3,
//            1,
//            3,
//            7
//        ],
//        "restingHeartRate": [
//            37,
//            37,
//            40,
//            39,
//            40,
//            39,
//            36
//        ],
//        "sleepHours": [
//            9.568055555555556,
//            8.070972222222222,
//            7.335555555555556,
//            7.746666666666666,
//            7.692083333333333,
//            7.289305555555556,
//            8.26763888888889
//        ],
//        "weight": [
//            57.20026734152947,
//            57.20026734152947,
//            57.20026734152947,
//            57.20026734152947,
//            57.20026734152947,
//            57.20026734152947,
//            57.20026734152947
//        ],
//        "generalFeeling": [
//            2,
//            2,
//            2.5,
//            5,
//            4,
//            3,
//            4
//        ],
//        "mood": [
//            3,
//            2,
//            3,
//            4,
//            4,
//            3,
//            4
//        ],
//        "energy": [
//            2,
//            2,
//            2,
//            5,
//            4,
//            3,
//            4
//        ],
//        "focus": [
//            2,
//            2,
//            2,
//            4,
//            4,
//            3,
//            4
//        ],
//        "vitality": [
//            2.25,
//            2,
//            2.375,
//            4.5,
//            4,
//            3,
//            4
//        ]
//    },
//    "most_important_metrics_dict": {
//        "lowHeartRateEvents": {
//            "correlation": -0.35656971619494043,
//            "local_percentage_change": -0.844106463878327,
//            "local_mean": 5.428571428571429,
//            "global_percentage_change": 0.7991836734693878,
//            "global_mean": 3.0172413793103448,
//            "importance": 1
//        }
//    },
//    "most_important_metrics_array": [
//        {
//            "correlation": -0.35656971619494043,
//            "local_percentage_change": -0.844106463878327,
//            "local_mean": 5.428571428571429,
//            "global_percentage_change": 0.7991836734693878,
//            "global_mean": 3.0172413793103448,
//            "importance": 1,
//            "metric": "lowHeartRateEvents"
//        }
//    ],
//    "most_important_preceding_data": {
//        "lowHeartRateEvents": [
//            18,
//            5,
//            1,
//            3,
//            1,
//            3,
//            7
//        ]
//    }
//}

/// Represents an insight / anomaly for a given metric of interest.
class YPDInsight: Identifiable, PrettyPrintable {
    
    /// The MOI type. This maps to the 'desired_metric' in the response JSON.
    var metricOfInterestType: YPDCheckinType
    
    /// The value assocaited with the metric of interest (e.g., the anomaly value).
    var metricOfInterestValue: Double
    
    /// The change in the metric of interest from the local mean to the global mean.
    var metricOfInterestGlobalChange: Double
    
    /// Global mean for the metric of interest.
    var metricOfInterestGlobalMean: Double
    
    /// Local mean.
    var metricOfInterestLocalMean: Double
    
    /// The local change (line of best fit) for the metric.
    var metricOfInterestLocalChange: Double

    /// The date associated with the insight.
    var date: Date
    
    /// The time period associated with the metric.
    var timePeriod: String = "while"
    
    /// A list of the most important metrics associated with the insight / anomaly.
    var mostImportantAnomalyMetrics: [YPDAnomalyMetric] = []
    
    init(
        metricOfInterestType: YPDCheckinType,
        metricOfInterestValue: Double,
        metricOfInterestGlobalChange: Double,
        metricOfInterestGlobalMean: Double,
        metricOfInterestLocalChange: Double,
        metricOfInterestLocalMean: Double,
        date: Date,
        timePeriod: String = "while",
        mostImportantAnomalyMetrics: [YPDAnomalyMetric]
    ) {
        self.metricOfInterestType = metricOfInterestType
        self.metricOfInterestValue = metricOfInterestValue
        self.metricOfInterestGlobalChange = metricOfInterestGlobalChange
        self.metricOfInterestGlobalMean = metricOfInterestGlobalMean
        self.metricOfInterestLocalChange = metricOfInterestLocalChange
        self.metricOfInterestLocalMean = metricOfInterestLocalMean
        self.date = date
        self.timePeriod = timePeriod
        self.mostImportantAnomalyMetrics = mostImportantAnomalyMetrics
    }
    
    convenience init(json: JSON){
        let metricOfInterestType = YPDCheckinType(rawValue: json["desired_metric"].stringValue) ?? .unknown
        let metricOfInterestValue = json["anomaly_value"].doubleValue
        
        let metricOfInterestGlobalChange = json["anomaly_metrics"]["global_percentage_change"].doubleValue
        let metricOfInterestGlobalMean = json["anomaly_metrics"]["global_mean"].doubleValue
        
        let metricOfInterestLocalChange = json["anomaly_metrics"]["local_percentage_change"].doubleValue
        let metricOfInterestLocalMean = json["anomaly_metrics"]["local_mean"].doubleValue
        
        let date = Date.from(isoString: json["anomaly_start_of_date"].stringValue)
                    
        // Fetch the dates associated with the preceding data.
        let precedingDataDates: [Date] = json["preceding_data"]["startOfDate"].arrayValue.map { Date.from(isoString: $0.stringValue) }
                
        var timePeriod: String = "while"
        
        if precedingDataDates.count >= 2 {
            timePeriod = moment(precedingDataDates.first!).from(precedingDataDates.last!, true)
        }
        
        let mostImportantMetrics = json["most_important_metrics_array"].arrayValue.map {
            
            YPDAnomalyMetric(json: $0, timePeriod: timePeriod, precedingData: zip(precedingDataDates, json["most_important_preceding_data"][$0["metric"].stringValue].arrayValue.map{$0.doubleValue}).map { $0 }
            )
            
        }
        
        self.init(
            metricOfInterestType: metricOfInterestType,
            metricOfInterestValue: metricOfInterestValue,
            metricOfInterestGlobalChange: metricOfInterestGlobalChange,
            metricOfInterestGlobalMean: metricOfInterestGlobalMean,
            metricOfInterestLocalChange: metricOfInterestLocalChange,
            metricOfInterestLocalMean: metricOfInterestLocalMean,
            date: date,
            timePeriod: timePeriod,
            mostImportantAnomalyMetrics: mostImportantMetrics
        )

    }
}
/// Represents a change in a given metric; used for displaying insights to the user.
class YPDAnomalyMetric: PrettyPrintable, Identifiable {
    
    var id = UUID()
    
    /// The metric attribute associated with the current insight.
    var metricAttribute: YPDCheckinType
    
    var localChange: Double
    var localMean: Double
    var globalChange: Double
    var globalMean: Double
    var timePeriod: String
    var importance: Double
    var correlation: Double
    
    var precedingData: [(Date, Double)]
    
    init(metricAttribute: YPDCheckinType, localChange: Double, localMean: Double, globalChange: Double, globalMean: Double, correlation: Double, importance: Double, timePeriod: String, precedingData: [(Date, Double)]){
        self.metricAttribute = metricAttribute
        self.localChange = localChange
        self.localMean = localMean
        self.globalChange = globalChange
        self.globalMean = globalMean
        self.correlation = correlation
        self.importance = importance
        self.timePeriod = timePeriod
        self.precedingData = precedingData
    }

    convenience init(json: JSON, timePeriod: String, precedingData: [(Date, Double)]) {
        self.init(metricAttribute: YPDCheckinType(rawValue: json["metric"].stringValue)!, localChange: json["local_percentage_change"].doubleValue, localMean: json["local_mean"].doubleValue, globalChange: json["global_percentage_change"].doubleValue, globalMean: json["global_mean"].doubleValue, correlation: json["correlation"].doubleValue, importance: json["importance"].doubleValue, timePeriod: timePeriod, precedingData: precedingData)

    }
    
}
