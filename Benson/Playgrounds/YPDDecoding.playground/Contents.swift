//
//  YPDInsight.swift
//  Benson
//
//  Created by Aaron Baw on 11/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
//import SwiftyJSON


extension Date {
    static func from(isoString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let parsedDate = formatter.date(from: isoString)
        //       self.log("Attempting to parse \(unenrichedCheckinInfo.stringValue) as a date: \(String(describing: parsedDate))")
        return parsedDate!
    }
}

/// Represents an insight / anomaly for a given metric of interest.
struct YPDInsight: Identifiable {
    
    var id: String?
    
    
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
    
//    init(json: JSON){
//        let metricOfInterestType = YPDCheckinType(rawValue: json["desired_metric"].stringValue) ?? .unknown
//        let metricOfInterestValue = json["anomaly_value"].doubleValue
//
//        let metricOfInterestGlobalChange = json["anomaly_metrics"]["global_percentage_change"].doubleValue
//        let metricOfInterestGlobalMean = json["anomaly_metrics"]["global_mean"].doubleValue
//
//        let metricOfInterestLocalChange = json["anomaly_metrics"]["local_percentage_change"].doubleValue
//        let metricOfInterestLocalMean = json["anomaly_metrics"]["local_mean"].doubleValue
//
//        let date = Date.from(isoString: json["anomaly_start_of_date"].stringValue)
//
//        // Fetch the dates associated with the preceding data.
//        let precedingDataDates: [Date] = json["preceding_data"]["startOfDate"].arrayValue.map { Date.from(isoString: $0.stringValue) }
//
//        let timePeriod: String = "while"
//
//        //    if precedingDataDates.count >= 2 {
//        //        timePeriod = moment(precedingDataDates.first!).from(precedingDataDates.last!, true)
//        //    }
//
//        let mostImportantMetrics = json["most_important_metrics_array"].arrayValue.map {
//
//            YPDAnomalyMetric(json: $0, timePeriod: timePeriod, precedingData: zip(precedingDataDates, json["most_important_preceding_data"][$0["metric"].stringValue].arrayValue.map{$0.doubleValue}).map { $0 }
//            )
//
//        }
//
//        self.init(
//            metricOfInterestType: metricOfInterestType,
//            metricOfInterestValue: metricOfInterestValue,
//            metricOfInterestGlobalChange: metricOfInterestGlobalChange,
//            metricOfInterestGlobalMean: metricOfInterestGlobalMean,
//            metricOfInterestLocalChange: metricOfInterestLocalChange,
//            metricOfInterestLocalMean: metricOfInterestLocalMean,
//            date: date,
//            timePeriod: timePeriod,
//            mostImportantAnomalyMetrics: mostImportantMetrics
//        )
//
//    }
}

/// Decodable YPDInsight extension.
extension YPDInsight: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case desiredMetric = "desired_metric"
        case anomalyIndex = "anomaly_index"
        case anomalyValue = "anomaly_value"
        case anomalyMetrics = "anomaly_metrics"
        case anomalyStartOfDate = "anomaly_start_of_date"
        case precedingData = "preceding_data"
        case mostImportantMetricsDict = "most_important_metrics_dict"
        case mostImportantMetricsArray = "most_important_metrics_array"
        case mostImportantPrecedingData = "most_important_preceding_data"
        
        enum AnomalyMetricCodingKeys: String, CodingKey {
            case correlation
            case localPercentageChange = "local_percentage_change"
            case localMean = "local_mean"
            case globalPercentageChange = "global_percentage_change"
            case globalMean = "global_mean"
            case importance
        }
        
        enum MostImportantMetricsCodingKeys: String, CodingKey {
            case correlation
            case localPercentageChange = "local_percentage_change"
            case localMean = "local_mean"
            case globalPercentageChange = "global_percentage_change"
            case globalMean = "global_mean"
            case importance, metric
        }
        
        enum PrecedingDataKeys: String, CodingKey {
            case activeEnergyBurned, basalEnergyBurned, caloricIntake, dietaryCarbohydrates, dietaryFats, dietaryProtein, exerciseMinutes, hrv, lowHeartRateEvents, restingHeartRate, sleepHours, standingMinutes, stepCount, weight, generalFeeling, mood, energy, focus, vitality, startOfDate
        }
        
        
        
        
    }
    
    init(from decoder: Decoder) throws {
        
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.metricOfInterestType = YPDCheckinType(try dataContainer.decode(String.self, forKey: .desiredMetric))
        self.metricOfInterestValue = try dataContainer.decode(Double.self, forKey: .anomalyValue)
        
        // Why is it that we need to refer to 'self' when referencing an enum that we would like our container to be keyed by, or when referencing a type that we would like to be decoded?
        let anomalyMetricsContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.AnomalyMetricCodingKeys.self, forKey: .anomalyMetrics)
        self.date = Date.from(isoString: try dataContainer
                                .decode(String.self, forKey: .anomalyStartOfDate))
        self.metricOfInterestGlobalChange = try anomalyMetricsContainer.decode(Double.self, forKey: .globalPercentageChange)
        self.metricOfInterestGlobalMean = try anomalyMetricsContainer.decode(Double.self, forKey: .globalMean)
        self.metricOfInterestLocalChange = try anomalyMetricsContainer.decode(Double.self, forKey: .localPercentageChange)
        self.metricOfInterestLocalMean = try anomalyMetricsContainer.decode(Double.self, forKey: .localMean)
        
        let precedingDataContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.PrecedingDataKeys.self, forKey: .precedingData)
        
        let precedingDataDates = (try precedingDataContainer.decode([String].self, forKey: .startOfDate)).map(Date.from(isoString:))
        
        self.timePeriod = "while"
        
        // Calculating the 'time period' string.
        if precedingDataDates.count >= 2 {
            self.timePeriod = moment(precedingDataDates.first!).from(precedingDataDates.last!, true)
        }
        
        self.mostImportantAnomalyMetrics = try dataContainer.decode([YPDAnomalyMetric].self, forKey: .mostImportantMetricsArray)
        
    }
    
}


/// The measurement or metric type.
// TODO: Refactor so that the metric types are inferred from the keys of the aggregated healthDataObject, from the backend.
enum YPDCheckinType: String, CaseIterable, Hashable, Identifiable, Codable {
    
    
    case generalFeeling
    case mood
    case energy
    case focus
    case vitality
    
    case hrv
    case caloricIntake
    case basalEnergyBurned
    case activeEnergyBurned
    case dietaryCarbohydrates
    case dietaryFats
    case dietaryProtein
    case lowHeartRateEvents
    case restingHeartRate
    case sleepHours
    case weight
    case standingMinutes
    case exerciseMinutes
    case mindfulSession
    case stepCount
    
    // Unknown case, occurring when we fail to initialise via a string value.
    case unknown
    
    /// Returns human readable sentences describing the metric type, converting from camelCase to a sentence.
    var humanReadable: String {
        return self.rawValue.map { "\($0.isUppercase ? " \($0)" : "\($0)")" }.joined(separator: "").capitalized
    }
    
    var id: String {
        self.rawValue
    }
    
    init(_ rawValue: String) {
        if let checkinType = YPDCheckinType(rawValue: rawValue) {
            self = checkinType
        } else {
            self = .unknown
        }
    }
}

/// Extensions for displaying date information.
//extension YPDInsight {
//
//    /// The human readable date associated with the given insight. (If the anomaly was detected today, it highlights so - otherwise, it describes the timeSince in human readable terms (e.g. "3 days ago").
//    var humanReadableDate: String {
//        let checkinDate = moment(self.date).startOf("day");
//        let today = moment(Date()).startOf("day");
//        let timeSinceString = checkinDate.isSame(today) ? "Today" : checkinDate.from(today)
//        return timeSinceString
//    }
//
//    /// Abbreviated date (DD/MM) for the insight.
//    var abbreviatedDateString: String {
//        let checkinDate = moment(self.date).startOf("day")
//        let shortDateString = checkinDate.format("DD/MM")
//        return shortDateString
//    }
//
//}

/// Represents a change in a given metric; used for displaying insights to the user.
struct YPDAnomalyMetric: Identifiable {
    
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
    
    /// The metric attribute which this appears to be affecting.
    var affectingMetricAttribute: YPDCheckinType?
    
    var precedingData: [(Date, Double)] = []
    
    init(metricAttribute: YPDCheckinType, affectingMetricAttribute: YPDCheckinType? = nil, localChange: Double, localMean: Double, globalChange: Double, globalMean: Double, correlation: Double, importance: Double, timePeriod: String, precedingData: [(Date, Double)]){
        self.metricAttribute = metricAttribute
        self.affectingMetricAttribute = affectingMetricAttribute
        self.localChange = localChange
        self.localMean = localMean
        self.globalChange = globalChange
        self.globalMean = globalMean
        self.correlation = correlation
        self.importance = importance
        self.timePeriod = timePeriod
        self.precedingData = precedingData
    }
    
//    init(json: JSON, timePeriod: String, precedingData: [(Date, Double)]) {
//        self.init(metricAttribute: YPDCheckinType(json["metric"].stringValue), localChange: json["local_percentage_change"].doubleValue, localMean: json["local_mean"].doubleValue, globalChange: json["global_percentage_change"].doubleValue, globalMean: json["global_mean"].doubleValue, correlation: json["correlation"].doubleValue, importance: json["importance"].doubleValue, timePeriod: timePeriod, precedingData: precedingData)
//    }
    
}

extension YPDAnomalyMetric: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case correlation
        case localPercentageChange = "local_percentage_change"
        case localMean = "local_mean"
        case globalPercentageChange = "global_percentage_change"
        case globalMean = "global_mean"
        case importance
        case metricAttribute = "metric"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.localChange = try container.decode(Double.self, forKey: .localPercentageChange)
        self.localMean = try container.decode(Double.self, forKey: .localMean)
        self.globalChange = try container.decode(Double.self, forKey: .globalPercentageChange)
        self.globalMean = try container.decode(Double.self, forKey: .globalMean)
        self.correlation = try container.decode(Double.self, forKey: .correlation)
        self.importance = try container.decode(Double.self, forKey: .importance)
        
        // We need to ensure that the metric attribute is contained within the object - as there are instances where this may not appear (depending which version of the anomaly metric is being decoded).
        let metricAttributeString = try container.decodeIfPresent(String.self, forKey: .metricAttribute)
        if let metricAttributeString = metricAttributeString {
            self.metricAttribute = YPDCheckinType(metricAttributeString)
        } else {
            self.metricAttribute = .unknown
        }
        
        self.timePeriod = "some time ago"
        
    }
    
}

var sampleJSONString = """
{
    "success": true,
    "data": [
        {
            "desired_metric": "vitality",
            "anomaly_index": 0,
            "anomaly_value": 1.25,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.5846153846153845,
                "local_mean": 2.25,
                "global_percentage_change": -0.20296222986289436,
                "global_mean": 2.8229527938342964
            },
            "anomaly_start_of_date": "2020-10-12T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-09-20T00:00:00.000Z",
                    "2020-09-21T00:00:00.000Z",
                    "2020-09-22T00:00:00.000Z",
                    "2020-09-25T00:00:00.000Z",
                    "2020-10-10T00:00:00.000Z",
                    "2020-10-11T00:00:00.000Z",
                    "2020-10-12T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    459.907,
                    375.8890000000006,
                    455.007,
                    569.9119999999917,
                    402.56900000000087,
                    31.278999999999996,
                    200.58699999999956
                ],
                "basalEnergyBurned": [
                    1615.0040000000013,
                    1584.3920000000014,
                    1404.0849999999987,
                    1579.7679999999627,
                    1562.2940000000008,
                    1547.1960000000001,
                    1565.910999999999
                ],
                "caloricIntake": [
                    995.9027499999999,
                    0,
                    0,
                    2136.8930779999996,
                    661.87,
                    2574.4522749999996,
                    899.1800000000001
                ],
                "dietaryCarbohydrates": [
                    58.97425,
                    0,
                    0,
                    192.83925999999997,
                    54.980199999999996,
                    132.73144,
                    67.98140000000001
                ],
                "dietaryFats": [
                    30.700650000000003,
                    0,
                    0,
                    67.93409500000001,
                    23.9106,
                    129.43258,
                    42.818200000000004
                ],
                "dietaryProtein": [
                    115.52768000000002,
                    0,
                    0,
                    192.24334699999997,
                    61.07420000000001,
                    225.66057000000004,
                    65.2384
                ],
                "exerciseMinutes": [
                    59,
                    33,
                    55,
                    81,
                    71,
                    1,
                    7
                ],
                "hrv": [
                    59.95102310180664,
                    64.09187371390206,
                    67.29346411568778,
                    44.13762855529785,
                    75.27041244506836,
                    73.31278991699219,
                    63.04589026314871
                ],
                "lowHeartRateEvents": [
                    0,
                    0,
                    6,
                    1,
                    3,
                    0,
                    1
                ],
                "restingHeartRate": [
                    44,
                    45,
                    43,
                    41,
                    39,
                    40,
                    40
                ],
                "sleepHours": [
                    0,
                    10.505370370370372,
                    11.505925925925926,
                    0,
                    7.737500000000001,
                    12.912777777777777,
                    7.788518518518519
                ],
                "standingMinutes": [
                    163,
                    66,
                    145,
                    128,
                    118,
                    6,
                    48
                ],
                "stepCount": [
                    11990.5,
                    6000,
                    12146.5,
                    12390.5,
                    8527,
                    7887,
                    2781
                ],
                "weight": [
                    72.22971803647022,
                    66.41974049204197,
                    60.60976294761372,
                    54.79978540318546,
                    55.16644530666361,
                    55.53310521014177,
                    55.89976511361992
                ],
                "generalFeeling": [
                    1,
                    2,
                    2,
                    3,
                    4,
                    3,
                    1
                ],
                "mood": [
                    1,
                    2,
                    3,
                    3,
                    5,
                    4,
                    2
                ],
                "energy": [
                    1,
                    1,
                    2,
                    1,
                    2,
                    3,
                    1
                ],
                "focus": [
                    1,
                    2,
                    3,
                    3,
                    3,
                    3,
                    1
                ],
                "vitality": [
                    1,
                    1.75,
                    2.5,
                    2.5,
                    3.5,
                    3.25,
                    1.25
                ]
            },
            "most_important_metrics_dict": {
                "dietaryFats": {
                    "correlation": 0.36566615607358205,
                    "local_percentage_change": 8.63289793514648,
                    "local_mean": 42.113732142857145,
                    "global_percentage_change": -0.293408944941529,
                    "global_mean": 59.60128116732556,
                    "importance": 1
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.36566615607358205,
                    "local_percentage_change": 8.63289793514648,
                    "local_mean": 42.113732142857145,
                    "global_percentage_change": -0.293408944941529,
                    "global_mean": 59.60128116732556,
                    "importance": 1,
                    "metric": "dietaryFats"
                }
            ],
            "most_important_preceding_data": {
                "dietaryFats": [
                    30.700650000000003,
                    0,
                    0,
                    67.93409500000001,
                    23.9106,
                    129.43258,
                    42.818200000000004
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 5,
            "anomaly_value": 1.75,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": -0.3614457831325302,
                "local_mean": 2.125,
                "global_percentage_change": -0.24724210598162244,
                "global_mean": 2.8229527938342964
            },
            "anomaly_start_of_date": "2020-09-21T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-09-12T00:00:00.000Z",
                    "2020-09-13T00:00:00.000Z",
                    "2020-09-15T00:00:00.000Z",
                    "2020-09-17T00:00:00.000Z",
                    "2020-09-19T00:00:00.000Z",
                    "2020-09-20T00:00:00.000Z",
                    "2020-09-21T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    349.72900000000016,
                    500.5199999999997,
                    338.57400000000064,
                    364.9790000000002,
                    524.243,
                    459.907,
                    375.8890000000006
                ],
                "basalEnergyBurned": [
                    1575.1909999999918,
                    1565.546999999996,
                    1554.7559999999876,
                    1582.6220000000003,
                    1561.8960000000027,
                    1615.0040000000013,
                    1584.3920000000014
                ],
                "caloricIntake": [
                    2235.520024,
                    872.690629,
                    2026.6288189999998,
                    1667.116675,
                    1901.9372,
                    995.9027499999999,
                    0
                ],
                "dietaryCarbohydrates": [
                    132.02911199999997,
                    47.31941499999999,
                    177.16800999999998,
                    128.016005,
                    143.1051,
                    58.97425,
                    0
                ],
                "dietaryFats": [
                    126.385192,
                    54.951215000000005,
                    74.94801,
                    62.04997000000001,
                    49.8178,
                    30.700650000000003,
                    0
                ],
                "dietaryProtein": [
                    143.06372799999997,
                    58.824186000000005,
                    162.483041,
                    155.762895,
                    208.83620000000002,
                    115.52768000000002,
                    0
                ],
                "exerciseMinutes": [
                    52,
                    68,
                    40,
                    41,
                    88,
                    59,
                    33
                ],
                "hrv": [
                    69.86854680379231,
                    71.8555793762207,
                    60.461255645751955,
                    57.985443115234375,
                    59.38325500488281,
                    59.95102310180664,
                    64.09187371390206
                ],
                "lowHeartRateEvents": [
                    4,
                    5,
                    6,
                    4,
                    0,
                    0,
                    0
                ],
                "restingHeartRate": [
                    39,
                    37,
                    37,
                    36,
                    41,
                    44,
                    45
                ],
                "sleepHours": [
                    12.565555555555555,
                    13.875833333333334,
                    12.263055555555555,
                    6.855833333333332,
                    13.49111111111111,
                    0,
                    10.505370370370372
                ],
                "standingMinutes": [
                    83,
                    126,
                    52,
                    78,
                    145,
                    163,
                    66
                ],
                "stepCount": [
                    6695.5,
                    10384.5,
                    6613,
                    4694,
                    11517.5,
                    11990.5,
                    6000
                ],
                "weight": [
                    82.64962221553301,
                    82.7995879872843,
                    82.94955375903557,
                    83.84967312532673,
                    78.03969558089848,
                    72.22971803647022,
                    66.41974049204197
                ],
                "generalFeeling": [
                    1,
                    4,
                    3,
                    3,
                    2.5,
                    1,
                    2
                ],
                "mood": [
                    2,
                    5,
                    4,
                    3,
                    2,
                    1,
                    2
                ],
                "energy": [
                    1,
                    3,
                    2,
                    1,
                    2,
                    1,
                    1
                ],
                "focus": [
                    1,
                    3,
                    2,
                    1,
                    3,
                    1,
                    2
                ],
                "vitality": [
                    1.25,
                    3.75,
                    2.75,
                    2,
                    2.375,
                    1,
                    1.75
                ]
            },
            "most_important_metrics_dict": {
                "sleepHours": {
                    "correlation": 0.634271093639893,
                    "local_percentage_change": -0.5214041595121821,
                    "local_mean": 9.936679894179893,
                    "global_percentage_change": 0.38092765825243724,
                    "global_mean": 7.195655641190323,
                    "importance": 1
                },
                "lowHeartRateEvents": {
                    "correlation": 0.5323928574486267,
                    "local_percentage_change": -1.05,
                    "local_mean": 2.7142857142857144,
                    "global_percentage_change": -0.15086540945492122,
                    "global_mean": 3.1965317919075145,
                    "importance": 0.6694517445611163
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.634271093639893,
                    "local_percentage_change": -0.5214041595121821,
                    "local_mean": 9.936679894179893,
                    "global_percentage_change": 0.38092765825243724,
                    "global_mean": 7.195655641190323,
                    "importance": 1,
                    "metric": "sleepHours"
                },
                {
                    "correlation": 0.5323928574486267,
                    "local_percentage_change": -1.05,
                    "local_mean": 2.7142857142857144,
                    "global_percentage_change": -0.15086540945492122,
                    "global_mean": 3.1965317919075145,
                    "importance": 0.6694517445611163,
                    "metric": "lowHeartRateEvents"
                }
            ],
            "most_important_preceding_data": {
                "sleepHours": [
                    12.565555555555555,
                    13.875833333333334,
                    12.263055555555555,
                    6.855833333333332,
                    13.49111111111111,
                    0,
                    10.505370370370372
                ],
                "lowHeartRateEvents": [
                    4,
                    5,
                    6,
                    4,
                    0,
                    0,
                    0
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 6,
            "anomaly_value": 1,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": -0.48,
                "local_mean": 2.375,
                "global_percentage_change": -0.15868235374416628,
                "global_mean": 2.8229527938342964
            },
            "anomaly_start_of_date": "2020-09-20T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-09-07T00:00:00.000Z",
                    "2020-09-12T00:00:00.000Z",
                    "2020-09-13T00:00:00.000Z",
                    "2020-09-15T00:00:00.000Z",
                    "2020-09-17T00:00:00.000Z",
                    "2020-09-19T00:00:00.000Z",
                    "2020-09-20T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    597.858000000005,
                    349.72900000000016,
                    500.5199999999997,
                    338.57400000000064,
                    364.9790000000002,
                    524.243,
                    459.907
                ],
                "basalEnergyBurned": [
                    1575.4140000000737,
                    1575.1909999999918,
                    1565.546999999996,
                    1554.7559999999876,
                    1582.6220000000003,
                    1561.8960000000027,
                    1615.0040000000013
                ],
                "caloricIntake": [
                    1826.986052,
                    2235.520024,
                    872.690629,
                    2026.6288189999998,
                    1667.116675,
                    1901.9372,
                    995.9027499999999
                ],
                "dietaryCarbohydrates": [
                    75.83031599999998,
                    132.02911199999997,
                    47.31941499999999,
                    177.16800999999998,
                    128.016005,
                    143.1051,
                    58.97425
                ],
                "dietaryFats": [
                    110.821936,
                    126.385192,
                    54.951215000000005,
                    74.94801,
                    62.04997000000001,
                    49.8178,
                    30.700650000000003
                ],
                "dietaryProtein": [
                    148.61414400000004,
                    143.06372799999997,
                    58.824186000000005,
                    162.483041,
                    155.762895,
                    208.83620000000002,
                    115.52768000000002
                ],
                "exerciseMinutes": [
                    91,
                    52,
                    68,
                    40,
                    41,
                    88,
                    59
                ],
                "hrv": [
                    67.81913344065349,
                    69.86854680379231,
                    71.8555793762207,
                    60.461255645751955,
                    57.985443115234375,
                    59.38325500488281,
                    59.95102310180664
                ],
                "lowHeartRateEvents": [
                    4,
                    4,
                    5,
                    6,
                    4,
                    0,
                    0
                ],
                "restingHeartRate": [
                    40,
                    39,
                    37,
                    37,
                    36,
                    41,
                    44
                ],
                "sleepHours": [
                    11.4525,
                    12.565555555555555,
                    13.875833333333334,
                    12.263055555555555,
                    6.855833333333332,
                    13.49111111111111,
                    0
                ],
                "standingMinutes": [
                    100,
                    83,
                    126,
                    52,
                    78,
                    145,
                    163
                ],
                "stepCount": [
                    6492,
                    6695.5,
                    10384.5,
                    6613,
                    4694,
                    11517.5,
                    11990.5
                ],
                "weight": [
                    69.17472789282519,
                    82.64962221553301,
                    82.7995879872843,
                    82.94955375903557,
                    83.84967312532673,
                    78.03969558089848,
                    72.22971803647022
                ],
                "generalFeeling": [
                    4,
                    1,
                    4,
                    3,
                    3,
                    2.5,
                    1
                ],
                "mood": [
                    4,
                    2,
                    5,
                    4,
                    3,
                    2,
                    1
                ],
                "energy": [
                    3,
                    1,
                    3,
                    2,
                    1,
                    2,
                    1
                ],
                "focus": [
                    3,
                    1,
                    3,
                    2,
                    1,
                    3,
                    1
                ],
                "vitality": [
                    3.5,
                    1.25,
                    3.75,
                    2.75,
                    2,
                    2.375,
                    1
                ]
            },
            "most_important_metrics_dict": {
                "sleepHours": {
                    "correlation": 0.6294971347921501,
                    "local_percentage_change": -0.5920156212187297,
                    "local_mean": 10.071984126984125,
                    "global_percentage_change": 0.39973125858451897,
                    "global_mean": 7.195655641190323,
                    "importance": 1
                },
                "standingMinutes": {
                    "correlation": -0.16641524864908375,
                    "local_percentage_change": 0.7250341997264023,
                    "local_mean": 106.71428571428571,
                    "global_percentage_change": 0.5520446766348404,
                    "global_mean": 68.75722543352602,
                    "importance": 0.44712690359575336
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.6294971347921501,
                    "local_percentage_change": -0.5920156212187297,
                    "local_mean": 10.071984126984125,
                    "global_percentage_change": 0.39973125858451897,
                    "global_mean": 7.195655641190323,
                    "importance": 1,
                    "metric": "sleepHours"
                },
                {
                    "correlation": -0.16641524864908375,
                    "local_percentage_change": 0.7250341997264023,
                    "local_mean": 106.71428571428571,
                    "global_percentage_change": 0.5520446766348404,
                    "global_mean": 68.75722543352602,
                    "importance": 0.44712690359575336,
                    "metric": "standingMinutes"
                }
            ],
            "most_important_preceding_data": {
                "sleepHours": [
                    11.4525,
                    12.565555555555555,
                    13.875833333333334,
                    12.263055555555555,
                    6.855833333333332,
                    13.49111111111111,
                    0
                ],
                "standingMinutes": [
                    100,
                    83,
                    126,
                    52,
                    78,
                    145,
                    163
                ]
            }
        }
    ]
}
"""

var sampleInsightJSONString = """
{
            "desired_metric": "vitality",
            "anomaly_index": 0,
            "anomaly_value": 1.25,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.5846153846153845,
                "local_mean": 2.25,
                "global_percentage_change": -0.20296222986289436,
                "global_mean": 2.8229527938342964
            },
            "anomaly_start_of_date": "2020-10-12T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-09-20T00:00:00.000Z",
                    "2020-09-21T00:00:00.000Z",
                    "2020-09-22T00:00:00.000Z",
                    "2020-09-25T00:00:00.000Z",
                    "2020-10-10T00:00:00.000Z",
                    "2020-10-11T00:00:00.000Z",
                    "2020-10-12T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    459.907,
                    375.8890000000006,
                    455.007,
                    569.9119999999917,
                    402.56900000000087,
                    31.278999999999996,
                    200.58699999999956
                ],
                "basalEnergyBurned": [
                    1615.0040000000013,
                    1584.3920000000014,
                    1404.0849999999987,
                    1579.7679999999627,
                    1562.2940000000008,
                    1547.1960000000001,
                    1565.910999999999
                ],
                "caloricIntake": [
                    995.9027499999999,
                    0,
                    0,
                    2136.8930779999996,
                    661.87,
                    2574.4522749999996,
                    899.1800000000001
                ],
                "dietaryCarbohydrates": [
                    58.97425,
                    0,
                    0,
                    192.83925999999997,
                    54.980199999999996,
                    132.73144,
                    67.98140000000001
                ],
                "dietaryFats": [
                    30.700650000000003,
                    0,
                    0,
                    67.93409500000001,
                    23.9106,
                    129.43258,
                    42.818200000000004
                ],
                "dietaryProtein": [
                    115.52768000000002,
                    0,
                    0,
                    192.24334699999997,
                    61.07420000000001,
                    225.66057000000004,
                    65.2384
                ],
                "exerciseMinutes": [
                    59,
                    33,
                    55,
                    81,
                    71,
                    1,
                    7
                ],
                "hrv": [
                    59.95102310180664,
                    64.09187371390206,
                    67.29346411568778,
                    44.13762855529785,
                    75.27041244506836,
                    73.31278991699219,
                    63.04589026314871
                ],
                "lowHeartRateEvents": [
                    0,
                    0,
                    6,
                    1,
                    3,
                    0,
                    1
                ],
                "restingHeartRate": [
                    44,
                    45,
                    43,
                    41,
                    39,
                    40,
                    40
                ],
                "sleepHours": [
                    0,
                    10.505370370370372,
                    11.505925925925926,
                    0,
                    7.737500000000001,
                    12.912777777777777,
                    7.788518518518519
                ],
                "standingMinutes": [
                    163,
                    66,
                    145,
                    128,
                    118,
                    6,
                    48
                ],
                "stepCount": [
                    11990.5,
                    6000,
                    12146.5,
                    12390.5,
                    8527,
                    7887,
                    2781
                ],
                "weight": [
                    72.22971803647022,
                    66.41974049204197,
                    60.60976294761372,
                    54.79978540318546,
                    55.16644530666361,
                    55.53310521014177,
                    55.89976511361992
                ],
                "generalFeeling": [
                    1,
                    2,
                    2,
                    3,
                    4,
                    3,
                    1
                ],
                "mood": [
                    1,
                    2,
                    3,
                    3,
                    5,
                    4,
                    2
                ],
                "energy": [
                    1,
                    1,
                    2,
                    1,
                    2,
                    3,
                    1
                ],
                "focus": [
                    1,
                    2,
                    3,
                    3,
                    3,
                    3,
                    1
                ],
                "vitality": [
                    1,
                    1.75,
                    2.5,
                    2.5,
                    3.5,
                    3.25,
                    1.25
                ]
            },
            "most_important_metrics_dict": {
                "dietaryFats": {
                    "correlation": 0.36566615607358205,
                    "local_percentage_change": 8.63289793514648,
                    "local_mean": 42.113732142857145,
                    "global_percentage_change": -0.293408944941529,
                    "global_mean": 59.60128116732556,
                    "importance": 1
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.36566615607358205,
                    "local_percentage_change": 8.63289793514648,
                    "local_mean": 42.113732142857145,
                    "global_percentage_change": -0.293408944941529,
                    "global_mean": 59.60128116732556,
                    "importance": 1,
                    "metric": "dietaryFats"
                }
            ],
            "most_important_preceding_data": {
                "dietaryFats": [
                    30.700650000000003,
                    0,
                    0,
                    67.93409500000001,
                    23.9106,
                    129.43258,
                    42.818200000000004
                ]
            }
        }
"""

var sampleAnomalyMetricJSON = """
[
                {
                    "correlation": 0.634271093639893,
                    "local_percentage_change": -0.5214041595121821,
                    "local_mean": 9.936679894179893,
                    "global_percentage_change": 0.38092765825243724,
                    "global_mean": 7.195655641190323,
                    "importance": 1,
                },
                {
                    "correlation": 0.5323928574486267,
                    "local_percentage_change": -1.05,
                    "local_mean": 2.7142857142857144,
                    "global_percentage_change": -0.15086540945492122,
                    "global_mean": 3.1965317919075145,
                    "importance": 0.6694517445611163,
                    "metric": "lowHeartRateEvents"
                }
            ]
"""
var sampleAnomalyJSONData = sampleAnomalyMetricJSON.data(using: .utf8)!
var sampleJSONData = sampleJSONString.data(using: .utf8)!
var sampleInsightJSONData = sampleInsightJSONString.data(using: .utf8)!

let decoded = try? JSONDecoder().decode(YPDInsight.self, from: sampleInsightJSONData)
