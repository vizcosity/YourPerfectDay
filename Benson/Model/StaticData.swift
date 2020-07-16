//
//  StaticData.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftyJSON

let _sampleCheckin = YPDCheckin(attributeValues: [YPDCheckinResponseValue(type: "mood", value: 3)], timeSince: "2 Hours Ago")
let _sampleMetricLogs: [YPDCheckin] = {
    var output: [YPDCheckin] = []
    for _ in 0..<10 {
        output.append(_sampleCheckin)
    }
    return output
}()

let _sampleAggregatedHealthAndCheckinData: JSON = {
    
    let defaultJSON = JSON(parseJSON: _sampleAggregatedHealthAndCheckinDataJsonString)["result"]
    
    guard let sampleDataPath = try? Bundle.main.path(forResource: "sample_chart_data", ofType: "json")?.asURL() else { return defaultJSON }
    guard let jsonData = try? Data(contentsOf: sampleDataPath) else { return defaultJSON }
    
    guard let json = try? JSON(data: jsonData) else { return defaultJSON["result"] }
    
    return json["result"]
    
}()


let _sampleAggregatedHealthAndCheckinDataJsonString = """
{
    "success": true,
    "result": [
        {
            "startOfDate": "2020-03-08T00:00:00.000Z",
            "activeEnergyBurned": 340.978999999999,
            "basalEnergyBurned": 1417.6336666666737,
            "caloricIntake": 1038.1900024414062,
            "dietaryCarbohydrates": 78.72500109672546,
            "dietaryFats": 43.48499917984009,
            "dietaryProtein": 79.49899899959564,
            "hrv": 59.27884052417896,
            "lowHeartRateEvents": 3.333333333333333,
            "restingHeartRate": 26.333333333333336,
            "sleepHours": 8.941898148148148,
            "weight": 0,
            "generalFeeling": 2.2,
            "mood": 2.8,
            "energy": 1.9999999999999998,
            "focus": 2.8,
            "attributesAndCounts": {
                "_id": 3,
                "startOfDay": 3,
                "activeEnergyBurned": 3,
                "basalEnergyBurned": 3,
                "caloricIntake": 2,
                "date": 3,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 3,
                "endOfDay": 3,
                "hrv": 3,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 3,
                "sleepHours": 3,
                "startDate": 3,
                "weight": 1,
                "workouts": 3,
                "generalFeeling": 5,
                "mood": 5,
                "energy": 5,
                "focus": 5
            }
        },
        {
            "startOfDate": "2020-05-03T00:00:00.000Z",
            "activeEnergyBurned": 562.5128000000009,
            "basalEnergyBurned": 1510.8201999999637,
            "caloricIntake": 1773.1075561523437,
            "dietaryCarbohydrates": 182.69813919067383,
            "dietaryFats": 55.959688091278075,
            "dietaryProtein": 129.9135913848877,
            "hrv": 58.00096934969463,
            "lowHeartRateEvents": 3.4,
            "restingHeartRate": 40.4,
            "sleepHours": 7.192611111111111,
            "weight": 29.99991732982521,
            "generalFeeling": 3.571428571428571,
            "mood": 3.428571428571428,
            "energy": 3.428571428571428,
            "focus": 3.2857142857142847,
            "attributesAndCounts": {
                "_id": 5,
                "startOfDay": 5,
                "activeEnergyBurned": 5,
                "basalEnergyBurned": 5,
                "caloricIntake": 5,
                "date": 5,
                "dietaryCarbohydrates": 5,
                "dietaryFats": 5,
                "dietaryProtein": 5,
                "endDate": 5,
                "endOfDay": 5,
                "hrv": 5,
                "lowHeartRateEvents": 5,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 5,
                "weight": 2,
                "workouts": 5,
                "generalFeeling": 7,
                "mood": 7,
                "energy": 7,
                "focus": 7
            }
        },
        {
            "startOfDate": "2019-12-01T00:00:00.000Z",
            "activeEnergyBurned": 393.3909999999995,
            "basalEnergyBurned": 1631.345999999996,
            "caloricIntake": 0,
            "dietaryCarbohydrates": 0,
            "dietaryFats": 0,
            "dietaryProtein": 0,
            "hrv": 70.9596939086914,
            "lowHeartRateEvents": 7,
            "restingHeartRate": 37,
            "sleepHours": 9.800555555555555,
            "weight": 0,
            "generalFeeling": 2.333333333333333,
            "mood": 3,
            "energy": 2.6666666666666665,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 1,
                "startOfDay": 1,
                "activeEnergyBurned": 1,
                "basalEnergyBurned": 1,
                "caloricIntake": 1,
                "date": 1,
                "dietaryCarbohydrates": 1,
                "dietaryFats": 1,
                "dietaryProtein": 1,
                "endDate": 1,
                "endOfDay": 1,
                "hrv": 1,
                "lowHeartRateEvents": 1,
                "restingHeartRate": 1,
                "sleepHours": 1,
                "startDate": 1,
                "weight": 1,
                "workouts": 1,
                "generalFeeling": 3,
                "mood": 3,
                "energy": 3,
                "focus": 3
            }
        },
        {
            "startOfDate": "2019-12-08T00:00:00.000Z",
            "activeEnergyBurned": 615.9937142857161,
            "basalEnergyBurned": 1678.8900000000124,
            "caloricIntake": 2123.3472791399277,
            "dietaryCarbohydrates": 203.85954138210843,
            "dietaryFats": 83.09073025839669,
            "dietaryProtein": 134.85908678599765,
            "hrv": 50.50681503775979,
            "lowHeartRateEvents": 2.25,
            "restingHeartRate": 48,
            "sleepHours": 6.369361111111111,
            "weight": 40.7335028966626,
            "generalFeeling": 2.6896551724137927,
            "mood": 2.862068965517242,
            "energy": 2.5862068965517238,
            "focus": 2.750000000000001,
            "attributesAndCounts": {
                "_id": 7,
                "startOfDay": 7,
                "activeEnergyBurned": 7,
                "basalEnergyBurned": 7,
                "caloricIntake": 7,
                "date": 7,
                "dietaryCarbohydrates": 7,
                "dietaryFats": 7,
                "dietaryProtein": 7,
                "endDate": 7,
                "endOfDay": 7,
                "hrv": 7,
                "lowHeartRateEvents": 4,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 7,
                "weight": 3,
                "workouts": 7,
                "generalFeeling": 29,
                "mood": 29,
                "energy": 29,
                "focus": 28
            }
        },
        {
            "startOfDate": "2019-12-15T00:00:00.000Z",
            "activeEnergyBurned": 682.4739999999998,
            "basalEnergyBurned": 1699.3502857142896,
            "caloricIntake": 2296.1245727539062,
            "dietaryCarbohydrates": 196.31819207327706,
            "dietaryFats": 82.91801561628068,
            "dietaryProtein": 152.02902930123466,
            "hrv": 55.13867860975719,
            "lowHeartRateEvents": 1.6666666666666665,
            "restingHeartRate": 69.4,
            "sleepHours": 6.3653055555555556,
            "weight": 46.50013400434147,
            "generalFeeling": 3.473684210526316,
            "mood": 3.842105263157894,
            "energy": 3.3157894736842106,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 7,
                "startOfDay": 7,
                "activeEnergyBurned": 7,
                "basalEnergyBurned": 7,
                "caloricIntake": 7,
                "date": 7,
                "dietaryCarbohydrates": 7,
                "dietaryFats": 7,
                "dietaryProtein": 7,
                "endDate": 7,
                "endOfDay": 7,
                "hrv": 7,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 7,
                "weight": 4,
                "workouts": 7,
                "generalFeeling": 19,
                "mood": 19,
                "energy": 19,
                "focus": 17
            }
        },
        {
            "startOfDate": "2019-12-22T00:00:00.000Z",
            "activeEnergyBurned": 451.38433333333114,
            "basalEnergyBurned": 1472.3243333333432,
            "caloricIntake": 2271.8370819091797,
            "dietaryCarbohydrates": 206.73236310482025,
            "dietaryFats": 68.73652410507202,
            "dietaryProtein": 157.6684055328369,
            "hrv": 53.24199763807671,
            "lowHeartRateEvents": 3,
            "restingHeartRate": 43.666666666666664,
            "sleepHours": 7.502951388888889,
            "weight": 0,
            "generalFeeling": 3.235294117647058,
            "mood": 3.2941176470588225,
            "energy": 2.647058823529412,
            "focus": 2.533333333333333,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 4,
                "date": 6,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 4,
                "restingHeartRate": 6,
                "sleepHours": 4,
                "startDate": 6,
                "weight": 1,
                "workouts": 6,
                "generalFeeling": 17,
                "mood": 17,
                "energy": 17,
                "focus": 15
            }
        },
        {
            "startOfDate": "2019-12-29T00:00:00.000Z",
            "activeEnergyBurned": 286.02999999999895,
            "basalEnergyBurned": 1143.7983333333405,
            "caloricIntake": 1914.0275955200195,
            "dietaryCarbohydrates": 189.53216135501862,
            "dietaryFats": 74.30047988891602,
            "dietaryProtein": 118.29718327522278,
            "hrv": 54.89510050501141,
            "lowHeartRateEvents": 1.6666666666666665,
            "restingHeartRate": 43.166666666666664,
            "sleepHours": 8.200694444444444,
            "weight": 0,
            "generalFeeling": 3.230769230769231,
            "mood": 3.1428571428571423,
            "energy": 2.8571428571428568,
            "focus": 2.6,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 2,
                "date": 6,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 6,
                "sleepHours": 6,
                "startDate": 6,
                "weight": 1,
                "workouts": 6,
                "generalFeeling": 13,
                "mood": 14,
                "energy": 14,
                "focus": 5
            }
        },
        {
            "startOfDate": "2020-01-05T00:00:00.000Z",
            "activeEnergyBurned": 417.035249999997,
            "basalEnergyBurned": 1192.9592500000122,
            "caloricIntake": 1347.2634582519531,
            "dietaryCarbohydrates": 149.2649974822998,
            "dietaryFats": 38.64584732055664,
            "dietaryProtein": 95.20543479919434,
            "hrv": 54.70451600551605,
            "lowHeartRateEvents": 1.6666666666666665,
            "restingHeartRate": 42,
            "sleepHours": 7.184374999999999,
            "weight": 40.76661425375,
            "generalFeeling": 2,
            "mood": 1.1666666666666665,
            "energy": 1.6666666666666665,
            "focus": 1.5,
            "attributesAndCounts": {
                "_id": 4,
                "startOfDay": 4,
                "activeEnergyBurned": 4,
                "basalEnergyBurned": 4,
                "caloricIntake": 2,
                "date": 4,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 4,
                "endOfDay": 4,
                "hrv": 4,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 4,
                "sleepHours": 4,
                "startDate": 4,
                "weight": 3,
                "workouts": 4,
                "generalFeeling": 6,
                "mood": 6,
                "energy": 6,
                "focus": 4
            }
        },
        {
            "startOfDate": "2020-01-12T00:00:00.000Z",
            "activeEnergyBurned": 508.9752857142852,
            "basalEnergyBurned": 1172.3982857142971,
            "caloricIntake": 2032.2488342285158,
            "dietaryCarbohydrates": 217.35096855163573,
            "dietaryFats": 52.31570029258728,
            "dietaryProtein": 125.51618232727051,
            "hrv": 46.474303768443406,
            "lowHeartRateEvents": 1.6666666666666665,
            "restingHeartRate": 35.714285714285715,
            "sleepHours": 6.4268888888888895,
            "weight": 46.45004996217514,
            "generalFeeling": 3.4,
            "mood": 3.2857142857142856,
            "energy": 3.2142857142857135,
            "focus": 2.9999999999999996,
            "attributesAndCounts": {
                "_id": 7,
                "startOfDay": 7,
                "activeEnergyBurned": 7,
                "basalEnergyBurned": 7,
                "caloricIntake": 5,
                "date": 7,
                "dietaryCarbohydrates": 5,
                "dietaryFats": 5,
                "dietaryProtein": 5,
                "endDate": 7,
                "endOfDay": 7,
                "hrv": 7,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 7,
                "sleepHours": 5,
                "startDate": 7,
                "weight": 4,
                "workouts": 7,
                "generalFeeling": 15,
                "mood": 14,
                "energy": 14,
                "focus": 11
            }
        },
        {
            "startOfDate": "2020-01-19T00:00:00.000Z",
            "activeEnergyBurned": 533.6498333333317,
            "basalEnergyBurned": 1529.9596666666662,
            "caloricIntake": 2084.1296157836914,
            "dietaryCarbohydrates": 198.64768462181092,
            "dietaryFats": 58.31116548776626,
            "dietaryProtein": 132.33440235853195,
            "hrv": 51.150036261422294,
            "lowHeartRateEvents": 4,
            "restingHeartRate": 43,
            "sleepHours": 5.8784374999999995,
            "weight": 46.52504884708298,
            "generalFeeling": 3.083333333333333,
            "mood": 3.416666666666667,
            "energy": 2.5833333333333335,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 5,
                "date": 6,
                "dietaryCarbohydrates": 5,
                "dietaryFats": 5,
                "dietaryProtein": 5,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 5,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 5,
                "sleepHours": 4,
                "startDate": 6,
                "weight": 4,
                "workouts": 6,
                "generalFeeling": 12,
                "mood": 12,
                "energy": 12,
                "focus": 8
            }
        },
        {
            "startOfDate": "2020-01-26T00:00:00.000Z",
            "activeEnergyBurned": 535.8595000000006,
            "basalEnergyBurned": 1555.7279999999985,
            "caloricIntake": 1642.1024780273438,
            "dietaryCarbohydrates": 186.48429012298584,
            "dietaryFats": 40.465237855911255,
            "dietaryProtein": 122.7815330028534,
            "hrv": 65.29354801177979,
            "lowHeartRateEvents": 2.9999999999999996,
            "restingHeartRate": 39.5,
            "sleepHours": 5.437395833333333,
            "weight": 63.366855011836044,
            "generalFeeling": 2.25,
            "mood": 2.875,
            "energy": 2.125,
            "focus": 1.8,
            "attributesAndCounts": {
                "_id": 4,
                "startOfDay": 4,
                "activeEnergyBurned": 4,
                "basalEnergyBurned": 4,
                "caloricIntake": 4,
                "date": 4,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 3,
                "dietaryProtein": 4,
                "endDate": 4,
                "endOfDay": 4,
                "hrv": 4,
                "lowHeartRateEvents": 3,
                "restingHeartRate": 4,
                "sleepHours": 4,
                "startDate": 4,
                "weight": 3,
                "workouts": 4,
                "generalFeeling": 8,
                "mood": 8,
                "energy": 8,
                "focus": 5
            }
        },
        {
            "startOfDate": "2020-02-02T00:00:00.000Z",
            "activeEnergyBurned": 600.1036666666658,
            "basalEnergyBurned": 1628.3938333333294,
            "caloricIntake": 1578.2244781494142,
            "dietaryCarbohydrates": 168.2116919994354,
            "dietaryFats": 39.25915849208832,
            "dietaryProtein": 112.35260949134826,
            "hrv": 67.4789608534051,
            "lowHeartRateEvents": 4.333333333333333,
            "restingHeartRate": 38.33333333333333,
            "sleepHours": 9.52650462962963,
            "weight": 0,
            "generalFeeling": 2.5,
            "mood": 2.857142857142857,
            "energy": 2.1666666666666665,
            "focus": 2.5,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 5,
                "date": 6,
                "dietaryCarbohydrates": 5,
                "dietaryFats": 4,
                "dietaryProtein": 5,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 6,
                "restingHeartRate": 6,
                "sleepHours": 6,
                "startDate": 6,
                "weight": 1,
                "workouts": 6,
                "generalFeeling": 6,
                "mood": 7,
                "energy": 6,
                "focus": 2
            }
        },
        {
            "startOfDate": "2020-02-09T00:00:00.000Z",
            "activeEnergyBurned": 620.6940000000006,
            "basalEnergyBurned": 1413.640600000016,
            "caloricIntake": 1388.658332824707,
            "dietaryCarbohydrates": 175.56012153625488,
            "dietaryFats": 31.128818333148956,
            "dietaryProtein": 94.12364935874939,
            "hrv": 75.34533321380616,
            "lowHeartRateEvents": 4.6,
            "restingHeartRate": 38,
            "sleepHours": 8.678805555555556,
            "weight": 0,
            "generalFeeling": 3.3,
            "mood": 3.1999999999999997,
            "energy": 3.0999999999999996,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 5,
                "startOfDay": 5,
                "activeEnergyBurned": 5,
                "basalEnergyBurned": 5,
                "caloricIntake": 4,
                "date": 5,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 5,
                "endOfDay": 5,
                "hrv": 5,
                "lowHeartRateEvents": 5,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 5,
                "weight": 1,
                "workouts": 5,
                "generalFeeling": 10,
                "mood": 10,
                "energy": 10,
                "focus": 6
            }
        },
        {
            "startOfDate": "2020-02-16T00:00:00.000Z",
            "activeEnergyBurned": 593.5514000000007,
            "basalEnergyBurned": 1577.468600000005,
            "caloricIntake": 1304.4840515136718,
            "dietaryCarbohydrates": 134.26183853149413,
            "dietaryFats": 55.370050847530365,
            "dietaryProtein": 90.22613468170167,
            "hrv": 72.31411459786553,
            "lowHeartRateEvents": 4.2,
            "restingHeartRate": 39,
            "sleepHours": 8.32913888888889,
            "weight": 61.149921380625,
            "generalFeeling": 2.625,
            "mood": 2.75,
            "energy": 2.5,
            "focus": 2.8571428571428568,
            "attributesAndCounts": {
                "_id": 5,
                "startOfDay": 5,
                "activeEnergyBurned": 5,
                "basalEnergyBurned": 5,
                "caloricIntake": 5,
                "date": 5,
                "dietaryCarbohydrates": 5,
                "dietaryFats": 4,
                "dietaryProtein": 5,
                "endDate": 5,
                "endOfDay": 5,
                "hrv": 5,
                "lowHeartRateEvents": 5,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 5,
                "weight": 2,
                "workouts": 5,
                "generalFeeling": 8,
                "mood": 8,
                "energy": 8,
                "focus": 7
            }
        },
        {
            "startOfDate": "2020-02-23T00:00:00.000Z",
            "activeEnergyBurned": 610.7361666666643,
            "basalEnergyBurned": 1531.6336666666682,
            "caloricIntake": 1952.4445343017578,
            "dietaryCarbohydrates": 204.1684023141861,
            "dietaryFats": 54.90177631378174,
            "dietaryProtein": 147.1943719983101,
            "hrv": 71.11743624096825,
            "lowHeartRateEvents": 3.8333333333333335,
            "restingHeartRate": 39.333333333333336,
            "sleepHours": 7.873379629629629,
            "weight": 30.29997170025406,
            "generalFeeling": 2.6,
            "mood": 2.8999999999999995,
            "energy": 2.6,
            "focus": 2.8,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 4,
                "date": 6,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 6,
                "restingHeartRate": 6,
                "sleepHours": 6,
                "startDate": 6,
                "weight": 2,
                "workouts": 6,
                "generalFeeling": 10,
                "mood": 10,
                "energy": 10,
                "focus": 10
            }
        },
        {
            "startOfDate": "2020-03-01T00:00:00.000Z",
            "activeEnergyBurned": 341.6165000000003,
            "basalEnergyBurned": 1110.1096666666667,
            "caloricIntake": 479.6940460205078,
            "dietaryCarbohydrates": 44.99419689178467,
            "dietaryFats": 16.348236918449402,
            "dietaryProtein": 32.38365173339844,
            "hrv": 69.77470355033876,
            "lowHeartRateEvents": 2.2,
            "restingHeartRate": 39.666666666666664,
            "sleepHours": 8.066944444444445,
            "weight": 40.46664178501963,
            "generalFeeling": 3.75,
            "mood": 4,
            "energy": 3.5,
            "focus": 3.3636363636363638,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 4,
                "date": 6,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 5,
                "restingHeartRate": 6,
                "sleepHours": 5,
                "startDate": 6,
                "weight": 3,
                "workouts": 6,
                "generalFeeling": 12,
                "mood": 12,
                "energy": 12,
                "focus": 11
            }
        },
        {
            "startOfDate": "2020-03-15T00:00:00.000Z",
            "activeEnergyBurned": 260.9994999999999,
            "basalEnergyBurned": 1590.02725,
            "caloricIntake": 951.9102325439453,
            "dietaryCarbohydrates": 83.18260678648949,
            "dietaryFats": 28.963277578353882,
            "dietaryProtein": 87.37516593933105,
            "hrv": 61.13182820479075,
            "lowHeartRateEvents": 2.5,
            "restingHeartRate": 39.5,
            "sleepHours": 8.281145833333333,
            "weight": 0,
            "generalFeeling": 3.75,
            "mood": 3.75,
            "energy": 3.75,
            "focus": 3.25,
            "attributesAndCounts": {
                "_id": 4,
                "startOfDay": 4,
                "activeEnergyBurned": 4,
                "basalEnergyBurned": 4,
                "caloricIntake": 4,
                "date": 4,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 4,
                "endOfDay": 4,
                "hrv": 4,
                "lowHeartRateEvents": 4,
                "restingHeartRate": 4,
                "sleepHours": 4,
                "startDate": 4,
                "weight": 1,
                "workouts": 4,
                "generalFeeling": 4,
                "mood": 4,
                "energy": 4,
                "focus": 4
            }
        },
        {
            "startOfDate": "2020-03-22T00:00:00.000Z",
            "activeEnergyBurned": 461.549000000001,
            "basalEnergyBurned": 1632.605999999974,
            "caloricIntake": 462.29345703125,
            "dietaryCarbohydrates": 57.702335357666016,
            "dietaryFats": 9.413344383239746,
            "dietaryProtein": 40.96971893310547,
            "hrv": 64.00793016524543,
            "lowHeartRateEvents": 3,
            "restingHeartRate": 40.5,
            "sleepHours": 6.887083333333333,
            "weight": 0,
            "generalFeeling": 3.4000000000000004,
            "mood": 3.4000000000000004,
            "energy": 2.8000000000000003,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 4,
                "startOfDay": 4,
                "activeEnergyBurned": 2,
                "basalEnergyBurned": 2,
                "caloricIntake": 2,
                "date": 4,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 4,
                "endOfDay": 4,
                "hrv": 2,
                "lowHeartRateEvents": 1,
                "restingHeartRate": 2,
                "sleepHours": 2,
                "startDate": 4,
                "weight": 1,
                "workouts": 4,
                "generalFeeling": 5,
                "mood": 5,
                "energy": 5,
                "focus": 5
            }
        },
        {
            "startOfDate": "2020-04-05T00:00:00.000Z",
            "activeEnergyBurned": 272.70100000000036,
            "basalEnergyBurned": 1559.7803999999978,
            "caloricIntake": 584.0817222595215,
            "dietaryCarbohydrates": 56.83063364028931,
            "dietaryFats": 23.089170694351196,
            "dietaryProtein": 41.3402304649353,
            "hrv": 63.52031254768372,
            "lowHeartRateEvents": 6.000000000000001,
            "restingHeartRate": 36.4,
            "sleepHours": 8.286972222222223,
            "weight": 59.60015437106196,
            "generalFeeling": 2.4285714285714284,
            "mood": 2.7142857142857144,
            "energy": 2.142857142857143,
            "focus": 2.428571428571428,
            "attributesAndCounts": {
                "_id": 5,
                "startOfDay": 5,
                "activeEnergyBurned": 5,
                "basalEnergyBurned": 5,
                "caloricIntake": 2,
                "date": 5,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 5,
                "endOfDay": 5,
                "hrv": 5,
                "lowHeartRateEvents": 5,
                "restingHeartRate": 5,
                "sleepHours": 5,
                "startDate": 5,
                "weight": 3,
                "workouts": 5,
                "generalFeeling": 7,
                "mood": 7,
                "energy": 7,
                "focus": 7
            }
        },
        {
            "startOfDate": "2020-04-19T00:00:00.000Z",
            "activeEnergyBurned": 429.96599999999967,
            "basalEnergyBurned": 1455.2219999999547,
            "caloricIntake": 670.1499786376953,
            "dietaryCarbohydrates": 70.60888051986694,
            "dietaryFats": 12.225557565689087,
            "dietaryProtein": 68.6999979019165,
            "hrv": 65.02819747924805,
            "lowHeartRateEvents": 13,
            "restingHeartRate": 39,
            "sleepHours": 9.944305555555555,
            "weight": 60.70018415817887,
            "generalFeeling": 3,
            "mood": 3,
            "energy": 3,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 1,
                "startOfDay": 1,
                "activeEnergyBurned": 1,
                "basalEnergyBurned": 1,
                "caloricIntake": 1,
                "date": 1,
                "dietaryCarbohydrates": 1,
                "dietaryFats": 1,
                "dietaryProtein": 1,
                "endDate": 1,
                "endOfDay": 1,
                "hrv": 1,
                "lowHeartRateEvents": 1,
                "restingHeartRate": 1,
                "sleepHours": 1,
                "startDate": 1,
                "weight": 1,
                "workouts": 1,
                "generalFeeling": 2,
                "mood": 2,
                "energy": 2,
                "focus": 2
            }
        },
        {
            "startOfDate": "2020-04-26T00:00:00.000Z",
            "activeEnergyBurned": 358.9308333333332,
            "basalEnergyBurned": 1356.9083333333153,
            "caloricIntake": 1255.9761810302734,
            "dietaryCarbohydrates": 112.77023140589395,
            "dietaryFats": 53.1177883942922,
            "dietaryProtein": 85.57573191324869,
            "hrv": 58.89130136701796,
            "lowHeartRateEvents": 4.5,
            "restingHeartRate": 38.33333333333333,
            "sleepHours": 7.038032407407408,
            "weight": 0,
            "generalFeeling": 2.6999999999999997,
            "mood": 2.8,
            "energy": 2.3,
            "focus": 2.714285714285714,
            "attributesAndCounts": {
                "_id": 6,
                "startOfDay": 6,
                "activeEnergyBurned": 6,
                "basalEnergyBurned": 6,
                "caloricIntake": 6,
                "date": 6,
                "dietaryCarbohydrates": 6,
                "dietaryFats": 6,
                "dietaryProtein": 6,
                "endDate": 6,
                "endOfDay": 6,
                "hrv": 6,
                "lowHeartRateEvents": 6,
                "restingHeartRate": 6,
                "sleepHours": 6,
                "startDate": 6,
                "weight": 1,
                "workouts": 6,
                "generalFeeling": 10,
                "mood": 10,
                "energy": 10,
                "focus": 7
            }
        },
        {
            "startOfDate": "2020-05-10T00:00:00.000Z",
            "activeEnergyBurned": 237.50149999999962,
            "basalEnergyBurned": 817.5714999999848,
            "caloricIntake": 560.8720932006836,
            "dietaryCarbohydrates": 31.959149837493896,
            "dietaryFats": 24.70499897003174,
            "dietaryProtein": 49.94804668426514,
            "hrv": 27.001519083976746,
            "lowHeartRateEvents": 5,
            "restingHeartRate": 18,
            "sleepHours": 3.7432638888888885,
            "weight": 0,
            "generalFeeling": 3.5,
            "mood": 3.5,
            "energy": 3,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 2,
                "startOfDay": 2,
                "activeEnergyBurned": 2,
                "basalEnergyBurned": 2,
                "caloricIntake": 2,
                "date": 2,
                "dietaryCarbohydrates": 2,
                "dietaryFats": 2,
                "dietaryProtein": 2,
                "endDate": 2,
                "endOfDay": 2,
                "hrv": 2,
                "lowHeartRateEvents": 2,
                "restingHeartRate": 2,
                "sleepHours": 2,
                "startDate": 2,
                "weight": 1,
                "workouts": 2,
                "generalFeeling": 2,
                "mood": 2,
                "energy": 2,
                "focus": 2
            }
        },
        {
            "startOfDate": "2020-05-17T00:00:00.000Z",
            "activeEnergyBurned": 353.4822500000001,
            "basalEnergyBurned": 1449.9172500000018,
            "caloricIntake": 1146.0695724487305,
            "dietaryCarbohydrates": 101.44236373901367,
            "dietaryFats": 44.532519817352295,
            "dietaryProtein": 85.08819580078125,
            "hrv": 64.26814530576979,
            "lowHeartRateEvents": 5.25,
            "restingHeartRate": 39,
            "sleepHours": 7.382187500000001,
            "weight": 0,
            "mood": 3.2,
            "generalFeeling": 3,
            "energy": 2.6,
            "focus": 3,
            "attributesAndCounts": {
                "_id": 4,
                "startOfDay": 4,
                "activeEnergyBurned": 4,
                "basalEnergyBurned": 4,
                "caloricIntake": 4,
                "date": 4,
                "dietaryCarbohydrates": 4,
                "dietaryFats": 4,
                "dietaryProtein": 4,
                "endDate": 4,
                "endOfDay": 4,
                "hrv": 4,
                "lowHeartRateEvents": 4,
                "restingHeartRate": 4,
                "sleepHours": 4,
                "startDate": 4,
                "weight": 1,
                "workouts": 4,
                "mood": 5,
                "generalFeeling": 5,
                "energy": 5,
                "focus": 5
            }
        }
    ]
}
"""
let sampleInsightsJsonString = """
{
    "success": true,
    "data": [
        {
            "desired_metric": "vitality",
            "anomaly_index": 9,
            "anomaly_value": 1,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": -0.136986301369863,
                "local_mean": 1.8214285714285714,
                "global_percentage_change": -0.3659764259546703,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-07-09T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-07-09T00:00:00.000Z",
                    "2020-07-04T00:00:00.000Z",
                    "2020-07-03T00:00:00.000Z",
                    "2020-07-01T00:00:00.000Z",
                    "2020-06-29T00:00:00.000Z",
                    "2020-06-28T00:00:00.000Z",
                    "2020-06-25T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    486.0109999999994,
                    53.88599999999994,
                    609.430999999999,
                    485.68399999999787,
                    380.51699999999954,
                    611.3859999999995,
                    551.6579999999993
                ],
                "basalEnergyBurned": [
                    1593.1030000000196,
                    812.7140000000003,
                    1614.7650000000012,
                    1576.8489999999997,
                    1594.8670000000002,
                    1609.4860000000251,
                    1606.7910000000008
                ],
                "caloricIntake": [
                    1323.7814331054688,
                    851.9059753417969,
                    1496.7840576171875,
                    1413.2069091796875,
                    1435.9744567871094,
                    1360.6980743408203,
                    2174.395233154297
                ],
                "dietaryCarbohydrates": [
                    122.91752433776855,
                    95.11075973510742,
                    129.95592498779297,
                    108.99594306945801,
                    137.1144676208496,
                    118.37918734550476,
                    197.69610595703125
                ],
                "dietaryFats": [
                    49.293020248413086,
                    22.593937873840332,
                    55.09947109222412,
                    54.627943992614746,
                    45.933624267578125,
                    52.53635787963867,
                    70.34383583068848
                ],
                "dietaryProtein": [
                    96.16678619384766,
                    67.05394554138184,
                    114.36804580688477,
                    121.06462478637695,
                    118.17030334472656,
                    102.40178394317627,
                    182.7882604598999
                ],
                "hrv": [
                    56.88869773017036,
                    60.983245849609375,
                    67.176748752594,
                    76.09923798697335,
                    64.8099242316352,
                    60.56422927162864,
                    69.82979965209961
                ],
                "lowHeartRateEvents": [
                    4,
                    1,
                    1,
                    10,
                    7,
                    2,
                    1
                ],
                "restingHeartRate": [
                    38,
                    40,
                    40,
                    36,
                    37,
                    39,
                    40
                ],
                "sleepHours": [
                    9.085138888888888,
                    8.88513888888889,
                    7.151111111111112,
                    6.369305555555555,
                    7.950555555555556,
                    13.095555555555556,
                    8.825694444444444
                ],
                "weight": [
                    58.487617127557805,
                    57.53756723030832,
                    57.300054755995944,
                    57.28009727310265,
                    57.26013979020935,
                    57.24018230731606,
                    57.220224824422765
                ],
                "generalFeeling": [
                    2,
                    2,
                    3,
                    2,
                    2,
                    3,
                    1
                ],
                "mood": [
                    2,
                    2.5,
                    4,
                    2,
                    1,
                    3,
                    1
                ],
                "energy": [
                    1,
                    1,
                    2,
                    1,
                    1,
                    3,
                    1
                ],
                "focus": [
                    1,
                    1.5,
                    3,
                    1,
                    1,
                    2,
                    1
                ],
                "vitality": [
                    1.5,
                    1.75,
                    3,
                    1.5,
                    1.25,
                    2.75,
                    1
                ]
            },
            "most_important_metrics_dict": {
                "dietaryProtein": {
                    "correlation": -0.3883851092020143,
                    "local_percentage_change": 0.9098427766478732,
                    "local_mean": 114.57339286804199,
                    "global_percentage_change": 0.23096180031426639,
                    "global_mean": 93.0763187279989,
                    "importance": 1
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.3883851092020143,
                    "local_percentage_change": 0.9098427766478732,
                    "local_mean": 114.57339286804199,
                    "global_percentage_change": 0.23096180031426639,
                    "global_mean": 93.0763187279989,
                    "importance": 1,
                    "metric": "dietaryProtein"
                }
            ],
            "most_important_preceding_data": {
                "dietaryProtein": [
                    96.16678619384766,
                    67.05394554138184,
                    114.36804580688477,
                    121.06462478637695,
                    118.17030334472656,
                    102.40178394317627,
                    182.7882604598999
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 5,
            "anomaly_value": 4.5,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 1.7391304347826098,
                "local_mean": 2.3035714285714284,
                "global_percentage_change": -0.19814665635443596,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-06-29T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-06-29T00:00:00.000Z",
                    "2020-06-28T00:00:00.000Z",
                    "2020-06-25T00:00:00.000Z",
                    "2020-06-24T00:00:00.000Z",
                    "2020-06-22T00:00:00.000Z",
                    "2020-06-21T00:00:00.000Z",
                    "2020-06-09T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    380.51699999999954,
                    611.3859999999995,
                    551.6579999999993,
                    265.06000000000006,
                    376.7889999999986,
                    513.0229999999899,
                    829.3399999999991
                ],
                "basalEnergyBurned": [
                    1594.8670000000002,
                    1609.4860000000251,
                    1606.7910000000008,
                    1582.1530000000005,
                    1577.5120000000165,
                    1573.9580000000585,
                    1608.338999999996
                ],
                "caloricIntake": [
                    1435.9744567871094,
                    1360.6980743408203,
                    2174.395233154297,
                    1888.4634246826172,
                    1837.265697479248,
                    854.8002319335938,
                    1643.7638244628906
                ],
                "dietaryCarbohydrates": [
                    137.1144676208496,
                    118.37918734550476,
                    197.69610595703125,
                    143.51368236541748,
                    190.30103492736816,
                    110.49192810058594,
                    127.2767574340105
                ],
                "dietaryFats": [
                    45.933624267578125,
                    52.53635787963867,
                    70.34383583068848,
                    80.5267858505249,
                    67.88369965553284,
                    9.083971977233887,
                    58.775335885584354
                ],
                "dietaryProtein": [
                    118.17030334472656,
                    102.40178394317627,
                    182.7882604598999,
                    143.0988302230835,
                    134.7524688243866,
                    74.5744857788086,
                    153.88283443450928
                ],
                "hrv": [
                    64.8099242316352,
                    60.56422927162864,
                    69.82979965209961,
                    56.054286411830354,
                    57.31756146748861,
                    66.1868109703064,
                    56.5038800239563
                ],
                "lowHeartRateEvents": [
                    7,
                    2,
                    1,
                    18,
                    5,
                    1,
                    3
                ],
                "restingHeartRate": [
                    37,
                    39,
                    40,
                    37,
                    37,
                    40,
                    39
                ],
                "sleepHours": [
                    7.950555555555556,
                    13.095555555555556,
                    8.825694444444444,
                    9.568055555555556,
                    8.070972222222222,
                    7.335555555555556,
                    7.746666666666666
                ],
                "weight": [
                    57.26013979020935,
                    57.24018230731606,
                    57.220224824422765,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947
                ],
                "generalFeeling": [
                    2,
                    3,
                    1,
                    2,
                    2,
                    2.5,
                    5
                ],
                "mood": [
                    1,
                    3,
                    1,
                    3,
                    2,
                    3,
                    4
                ],
                "energy": [
                    1,
                    3,
                    1,
                    2,
                    2,
                    2,
                    5
                ],
                "focus": [
                    1,
                    2,
                    1,
                    2,
                    2,
                    2,
                    4
                ],
                "vitality": [
                    1.25,
                    2.75,
                    1,
                    2.25,
                    2,
                    2.375,
                    4.5
                ]
            },
            "most_important_metrics_dict": {
                "lowHeartRateEvents": {
                    "correlation": -0.0868531014800035,
                    "local_percentage_change": -0.3370786516853933,
                    "local_mean": 5.285714285714286,
                    "global_percentage_change": 0.7518367346938775,
                    "global_mean": 3.0172413793103448,
                    "importance": 1
                },
                "activeEnergyBurned": {
                    "correlation": 0.6866397418805488,
                    "local_percentage_change": 0.5228855930422973,
                    "local_mean": 503.9675714285695,
                    "global_percentage_change": 0.028671637803520555,
                    "global_mean": 489.9207413793096,
                    "importance": 0.46767913302058506
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.0868531014800035,
                    "local_percentage_change": -0.3370786516853933,
                    "local_mean": 5.285714285714286,
                    "global_percentage_change": 0.7518367346938775,
                    "global_mean": 3.0172413793103448,
                    "importance": 1,
                    "metric": "lowHeartRateEvents"
                },
                {
                    "correlation": 0.6866397418805488,
                    "local_percentage_change": 0.5228855930422973,
                    "local_mean": 503.9675714285695,
                    "global_percentage_change": 0.028671637803520555,
                    "global_mean": 489.9207413793096,
                    "importance": 0.46767913302058506,
                    "metric": "activeEnergyBurned"
                }
            ],
            "most_important_preceding_data": {
                "lowHeartRateEvents": [
                    7,
                    2,
                    1,
                    18,
                    5,
                    1,
                    3
                ],
                "activeEnergyBurned": [
                    380.51699999999954,
                    611.3859999999995,
                    551.6579999999993,
                    265.06000000000006,
                    376.7889999999986,
                    513.0229999999899,
                    829.3399999999991
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 4,
            "anomaly_value": 4,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 1.5218658892128283,
                "local_mean": 2.6964285714285716,
                "global_percentage_change": -0.06139647371720791,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-06-28T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-06-28T00:00:00.000Z",
                    "2020-06-25T00:00:00.000Z",
                    "2020-06-24T00:00:00.000Z",
                    "2020-06-22T00:00:00.000Z",
                    "2020-06-21T00:00:00.000Z",
                    "2020-06-09T00:00:00.000Z",
                    "2020-06-08T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    611.3859999999995,
                    551.6579999999993,
                    265.06000000000006,
                    376.7889999999986,
                    513.0229999999899,
                    829.3399999999991,
                    590.7119999999884
                ],
                "basalEnergyBurned": [
                    1609.4860000000251,
                    1606.7910000000008,
                    1582.1530000000005,
                    1577.5120000000165,
                    1573.9580000000585,
                    1608.338999999996,
                    1366.8410000000229
                ],
                "caloricIntake": [
                    1360.6980743408203,
                    2174.395233154297,
                    1888.4634246826172,
                    1837.265697479248,
                    854.8002319335938,
                    1643.7638244628906,
                    873.8393249511719
                ],
                "dietaryCarbohydrates": [
                    118.37918734550476,
                    197.69610595703125,
                    143.51368236541748,
                    190.30103492736816,
                    110.49192810058594,
                    127.2767574340105,
                    92.45075798034668
                ],
                "dietaryFats": [
                    52.53635787963867,
                    70.34383583068848,
                    80.5267858505249,
                    67.88369965553284,
                    9.083971977233887,
                    58.775335885584354,
                    22.818938732147217
                ],
                "dietaryProtein": [
                    102.40178394317627,
                    182.7882604598999,
                    143.0988302230835,
                    134.7524688243866,
                    74.5744857788086,
                    153.88283443450928,
                    72.62894439697266
                ],
                "hrv": [
                    60.56422927162864,
                    69.82979965209961,
                    56.054286411830354,
                    57.31756146748861,
                    66.1868109703064,
                    56.5038800239563,
                    42.29812971750895
                ],
                "lowHeartRateEvents": [
                    2,
                    1,
                    18,
                    5,
                    1,
                    3,
                    1
                ],
                "restingHeartRate": [
                    39,
                    40,
                    37,
                    37,
                    40,
                    39,
                    40
                ],
                "sleepHours": [
                    13.095555555555556,
                    8.825694444444444,
                    9.568055555555556,
                    8.070972222222222,
                    7.335555555555556,
                    7.746666666666666,
                    7.692083333333333
                ],
                "weight": [
                    57.24018230731606,
                    57.220224824422765,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947
                ],
                "generalFeeling": [
                    3,
                    1,
                    2,
                    2,
                    2.5,
                    5,
                    4
                ],
                "mood": [
                    3,
                    1,
                    3,
                    2,
                    3,
                    4,
                    4
                ],
                "energy": [
                    3,
                    1,
                    2,
                    2,
                    2,
                    5,
                    4
                ],
                "focus": [
                    2,
                    1,
                    2,
                    2,
                    2,
                    4,
                    4
                ],
                "vitality": [
                    2.75,
                    1,
                    2.25,
                    2,
                    2.375,
                    4.5,
                    4
                ]
            },
            "most_important_metrics_dict": {
                "dietaryFats": {
                    "correlation": -0.35413018605590574,
                    "local_percentage_change": -0.5514521103200576,
                    "local_mean": 51.70984654447862,
                    "global_percentage_change": 0.21277701342247224,
                    "global_mean": 42.6375549438827,
                    "importance": 1
                },
                "lowHeartRateEvents": {
                    "correlation": -0.1515435831601226,
                    "local_percentage_change": -0.5581395348837208,
                    "local_mean": 4.428571428571429,
                    "global_percentage_change": 0.4677551020408164,
                    "global_mean": 3.0172413793103448,
                    "importance": 0.9521457027508455
                },
                "dietaryProtein": {
                    "correlation": -0.381464391528554,
                    "local_percentage_change": -0.3153238096862352,
                    "local_mean": 123.44680115154812,
                    "global_percentage_change": 0.32629655790644496,
                    "global_mean": 93.0763187279989,
                    "importance": 0.944556198253375
                },
                "caloricIntake": {
                    "correlation": -0.5197839419536863,
                    "local_percentage_change": -0.4010009423453642,
                    "local_mean": 1519.0322587149483,
                    "global_percentage_change": 0.17976580580481727,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.9017369752351639
                },
                "dietaryCarbohydrates": {
                    "correlation": -0.7325151530560805,
                    "local_percentage_change": -0.3229418870667883,
                    "local_mean": 140.0156363014664,
                    "global_percentage_change": 0.15138922097570617,
                    "global_mean": 121.60582516380939,
                    "importance": 0.8618674647982519
                },
                "sleepHours": {
                    "correlation": -0.1754109147444988,
                    "local_percentage_change": -0.39726597914398487,
                    "local_mean": 8.904940476190475,
                    "global_percentage_change": 0.2894643988418315,
                    "global_mean": 6.9059219348659,
                    "importance": 0.4854423777049678
                },
                "activeEnergyBurned": {
                    "correlation": 0.6314535235082581,
                    "local_percentage_change": 0.34945356902130675,
                    "local_mean": 533.995428571425,
                    "global_percentage_change": 0.08996289291208348,
                    "global_mean": 489.9207413793096,
                    "importance": 0.47774794141454
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.35413018605590574,
                    "local_percentage_change": -0.5514521103200576,
                    "local_mean": 51.70984654447862,
                    "global_percentage_change": 0.21277701342247224,
                    "global_mean": 42.6375549438827,
                    "importance": 1,
                    "metric": "dietaryFats"
                },
                {
                    "correlation": -0.1515435831601226,
                    "local_percentage_change": -0.5581395348837208,
                    "local_mean": 4.428571428571429,
                    "global_percentage_change": 0.4677551020408164,
                    "global_mean": 3.0172413793103448,
                    "importance": 0.9521457027508455,
                    "metric": "lowHeartRateEvents"
                },
                {
                    "correlation": -0.381464391528554,
                    "local_percentage_change": -0.3153238096862352,
                    "local_mean": 123.44680115154812,
                    "global_percentage_change": 0.32629655790644496,
                    "global_mean": 93.0763187279989,
                    "importance": 0.944556198253375,
                    "metric": "dietaryProtein"
                },
                {
                    "correlation": -0.5197839419536863,
                    "local_percentage_change": -0.4010009423453642,
                    "local_mean": 1519.0322587149483,
                    "global_percentage_change": 0.17976580580481727,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.9017369752351639,
                    "metric": "caloricIntake"
                },
                {
                    "correlation": -0.7325151530560805,
                    "local_percentage_change": -0.3229418870667883,
                    "local_mean": 140.0156363014664,
                    "global_percentage_change": 0.15138922097570617,
                    "global_mean": 121.60582516380939,
                    "importance": 0.8618674647982519,
                    "metric": "dietaryCarbohydrates"
                },
                {
                    "correlation": -0.1754109147444988,
                    "local_percentage_change": -0.39726597914398487,
                    "local_mean": 8.904940476190475,
                    "global_percentage_change": 0.2894643988418315,
                    "global_mean": 6.9059219348659,
                    "importance": 0.4854423777049678,
                    "metric": "sleepHours"
                },
                {
                    "correlation": 0.6314535235082581,
                    "local_percentage_change": 0.34945356902130675,
                    "local_mean": 533.995428571425,
                    "global_percentage_change": 0.08996289291208348,
                    "global_mean": 489.9207413793096,
                    "importance": 0.47774794141454,
                    "metric": "activeEnergyBurned"
                }
            ],
            "most_important_preceding_data": {
                "dietaryFats": [
                    52.53635787963867,
                    70.34383583068848,
                    80.5267858505249,
                    67.88369965553284,
                    9.083971977233887,
                    58.775335885584354,
                    22.818938732147217
                ],
                "lowHeartRateEvents": [
                    2,
                    1,
                    18,
                    5,
                    1,
                    3,
                    1
                ],
                "dietaryProtein": [
                    102.40178394317627,
                    182.7882604598999,
                    143.0988302230835,
                    134.7524688243866,
                    74.5744857788086,
                    153.88283443450928,
                    72.62894439697266
                ],
                "caloricIntake": [
                    1360.6980743408203,
                    2174.395233154297,
                    1888.4634246826172,
                    1837.265697479248,
                    854.8002319335938,
                    1643.7638244628906,
                    873.8393249511719
                ],
                "dietaryCarbohydrates": [
                    118.37918734550476,
                    197.69610595703125,
                    143.51368236541748,
                    190.30103492736816,
                    110.49192810058594,
                    127.2767574340105,
                    92.45075798034668
                ],
                "sleepHours": [
                    13.095555555555556,
                    8.825694444444444,
                    9.568055555555556,
                    8.070972222222222,
                    7.335555555555556,
                    7.746666666666666,
                    7.692083333333333
                ],
                "activeEnergyBurned": [
                    611.3859999999995,
                    551.6579999999993,
                    265.06000000000006,
                    376.7889999999986,
                    513.0229999999899,
                    829.3399999999991,
                    590.7119999999884
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 2,
            "anomaly_value": 4,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.8606060606060608,
                "local_mean": 3.1607142857142856,
                "global_percentage_change": 0.100217378490425,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-06-24T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-06-24T00:00:00.000Z",
                    "2020-06-22T00:00:00.000Z",
                    "2020-06-21T00:00:00.000Z",
                    "2020-06-09T00:00:00.000Z",
                    "2020-06-08T00:00:00.000Z",
                    "2020-06-04T00:00:00.000Z",
                    "2020-05-31T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    265.06000000000006,
                    376.7889999999986,
                    513.0229999999899,
                    829.3399999999991,
                    590.7119999999884,
                    635.640999999996,
                    560.609999999982
                ],
                "basalEnergyBurned": [
                    1582.1530000000005,
                    1577.5120000000165,
                    1573.9580000000585,
                    1608.338999999996,
                    1366.8410000000229,
                    1676.3500000000147,
                    1119.0550000000235
                ],
                "caloricIntake": [
                    1888.4634246826172,
                    1837.265697479248,
                    854.8002319335938,
                    1643.7638244628906,
                    873.8393249511719,
                    883.6720123291016,
                    604.7999877929688
                ],
                "dietaryCarbohydrates": [
                    143.51368236541748,
                    190.30103492736816,
                    110.49192810058594,
                    127.2767574340105,
                    92.45075798034668,
                    48.61190986633301,
                    67.1050033569336
                ],
                "dietaryFats": [
                    80.5267858505249,
                    67.88369965553284,
                    9.083971977233887,
                    58.775335885584354,
                    22.818938732147217,
                    22.84429109096527,
                    25.11750030517578
                ],
                "dietaryProtein": [
                    143.0988302230835,
                    134.7524688243866,
                    74.5744857788086,
                    153.88283443450928,
                    72.62894439697266,
                    118.38497161865234,
                    26.575000762939453
                ],
                "hrv": [
                    56.054286411830354,
                    57.31756146748861,
                    66.1868109703064,
                    56.5038800239563,
                    42.29812971750895,
                    53.66749978065491,
                    57.22919591267904
                ],
                "lowHeartRateEvents": [
                    18,
                    5,
                    1,
                    3,
                    1,
                    3,
                    7
                ],
                "restingHeartRate": [
                    37,
                    37,
                    40,
                    39,
                    40,
                    39,
                    36
                ],
                "sleepHours": [
                    9.568055555555556,
                    8.070972222222222,
                    7.335555555555556,
                    7.746666666666666,
                    7.692083333333333,
                    7.289305555555556,
                    8.26763888888889
                ],
                "weight": [
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947,
                    57.20026734152947
                ],
                "generalFeeling": [
                    2,
                    2,
                    2.5,
                    5,
                    4,
                    3,
                    4
                ],
                "mood": [
                    3,
                    2,
                    3,
                    4,
                    4,
                    3,
                    4
                ],
                "energy": [
                    2,
                    2,
                    2,
                    5,
                    4,
                    3,
                    4
                ],
                "focus": [
                    2,
                    2,
                    2,
                    4,
                    4,
                    3,
                    4
                ],
                "vitality": [
                    2.25,
                    2,
                    2.375,
                    4.5,
                    4,
                    3,
                    4
                ]
            },
            "most_important_metrics_dict": {
                "lowHeartRateEvents": {
                    "correlation": -0.35656971619494043,
                    "local_percentage_change": -0.844106463878327,
                    "local_mean": 5.428571428571429,
                    "global_percentage_change": 0.7991836734693878,
                    "global_mean": 3.0172413793103448,
                    "importance": 1
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.35656971619494043,
                    "local_percentage_change": -0.844106463878327,
                    "local_mean": 5.428571428571429,
                    "global_percentage_change": 0.7991836734693878,
                    "global_mean": 3.0172413793103448,
                    "importance": 1,
                    "metric": "lowHeartRateEvents"
                }
            ],
            "most_important_preceding_data": {
                "lowHeartRateEvents": [
                    18,
                    5,
                    1,
                    3,
                    1,
                    3,
                    7
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 99,
            "anomaly_value": 4,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.2893890675241162,
                "local_mean": 3.1785714285714284,
                "global_percentage_change": 0.1064332958830263,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-05-22T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-05-22T00:00:00.000Z",
                    "2020-05-20T00:00:00.000Z",
                    "2020-05-19T00:00:00.000Z",
                    "2020-05-18T00:00:00.000Z",
                    "2020-05-11T00:00:00.000Z",
                    "2020-05-09T00:00:00.000Z",
                    "2020-05-06T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    222.14600000000047,
                    595.7909999999999,
                    416.32199999999995,
                    179.66999999999993,
                    475.00299999999925,
                    500.5039999999985,
                    468.1350000000006
                ],
                "basalEnergyBurned": [
                    1370.5910000000129,
                    1619.8179999999966,
                    1505.602999999997,
                    1303.6570000000002,
                    1635.1429999999696,
                    1014.9239999999382,
                    1624.4799999999655
                ],
                "caloricIntake": [
                    1994.4903259277344,
                    1652.0244750976562,
                    937.7634887695312,
                    0,
                    1121.7441864013672,
                    404.550048828125,
                    1947.1421203613281
                ],
                "dietaryCarbohydrates": [
                    155.2663230895996,
                    136.03812789916992,
                    114.46500396728516,
                    0,
                    63.91829967498779,
                    59.29166793823242,
                    177.83512115478516
                ],
                "dietaryFats": [
                    82.67016410827637,
                    75.7269229888916,
                    19.73299217224121,
                    0,
                    49.40999794006348,
                    9.753334999084473,
                    80.74243927001953
                ],
                "dietaryProtein": [
                    161.79902267456055,
                    103.93294143676758,
                    74.62081909179688,
                    0,
                    99.89609336853027,
                    20.685001373291016,
                    111.29000091552734
                ],
                "hrv": [
                    64.9812616620745,
                    55.25979423522949,
                    59.50112533569336,
                    77.33039999008179,
                    54.00303816795349,
                    67.01877136230469,
                    64.17459640502929
                ],
                "lowHeartRateEvents": [
                    10,
                    6,
                    4,
                    1,
                    10,
                    2,
                    8
                ],
                "restingHeartRate": [
                    36,
                    41,
                    39,
                    40,
                    36,
                    39,
                    39
                ],
                "sleepHours": [
                    8.382083333333334,
                    4.995833333333334,
                    7.967638888888889,
                    8.183194444444446,
                    7.486527777777777,
                    8.784027777777778,
                    8.274583333333334
                ],
                "weight": [
                    59.22343912873198,
                    59.35283838388506,
                    59.482237639038125,
                    59.6116368941912,
                    59.741036149344275,
                    59.99983465965042,
                    60.069869609503264
                ],
                "generalFeeling": [
                    2.5,
                    4,
                    3,
                    3,
                    3,
                    3.5,
                    4
                ],
                "mood": [
                    2.5,
                    4,
                    3,
                    4,
                    2,
                    3.5,
                    4
                ],
                "energy": [
                    2.5,
                    3,
                    2,
                    3,
                    2,
                    3.5,
                    4
                ],
                "focus": [
                    2.5,
                    4,
                    3,
                    3,
                    3,
                    3.5,
                    4
                ],
                "vitality": [
                    2.5,
                    3.75,
                    2.75,
                    3.25,
                    2.5,
                    3.5,
                    4
                ]
            },
            "most_important_metrics_dict": {
                "lowHeartRateEvents": {
                    "correlation": -0.34164566431507165,
                    "local_percentage_change": -0.25531914893617036,
                    "local_mean": 5.857142857142857,
                    "global_percentage_change": 0.9412244897959183,
                    "global_mean": 3.0172413793103448,
                    "importance": 1
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.34164566431507165,
                    "local_percentage_change": -0.25531914893617036,
                    "local_mean": 5.857142857142857,
                    "global_percentage_change": 0.9412244897959183,
                    "global_mean": 3.0172413793103448,
                    "importance": 1,
                    "metric": "lowHeartRateEvents"
                }
            ],
            "most_important_preceding_data": {
                "lowHeartRateEvents": [
                    10,
                    6,
                    4,
                    1,
                    10,
                    2,
                    8
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 98,
            "anomaly_value": 4.25,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.30630630630630673,
                "local_mean": 3.4285714285714284,
                "global_percentage_change": 0.19345613937944406,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-05-20T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-05-20T00:00:00.000Z",
                    "2020-05-19T00:00:00.000Z",
                    "2020-05-18T00:00:00.000Z",
                    "2020-05-11T00:00:00.000Z",
                    "2020-05-09T00:00:00.000Z",
                    "2020-05-06T00:00:00.000Z",
                    "2020-05-05T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    595.7909999999999,
                    416.32199999999995,
                    179.66999999999993,
                    475.00299999999925,
                    500.5039999999985,
                    468.1350000000006,
                    571.0280000000006
                ],
                "basalEnergyBurned": [
                    1619.8179999999966,
                    1505.602999999997,
                    1303.6570000000002,
                    1635.1429999999696,
                    1014.9239999999382,
                    1624.4799999999655,
                    1632.7779999999586
                ],
                "caloricIntake": [
                    1652.0244750976562,
                    937.7634887695312,
                    0,
                    1121.7441864013672,
                    404.550048828125,
                    1947.1421203613281,
                    1950.9067077636719
                ],
                "dietaryCarbohydrates": [
                    136.03812789916992,
                    114.46500396728516,
                    0,
                    63.91829967498779,
                    59.29166793823242,
                    177.83512115478516,
                    163.8301010131836
                ],
                "dietaryFats": [
                    75.7269229888916,
                    19.73299217224121,
                    0,
                    49.40999794006348,
                    9.753334999084473,
                    80.74243927001953,
                    61.02450370788574
                ],
                "dietaryProtein": [
                    103.93294143676758,
                    74.62081909179688,
                    0,
                    99.89609336853027,
                    20.685001373291016,
                    111.29000091552734,
                    182.27032852172852
                ],
                "hrv": [
                    55.25979423522949,
                    59.50112533569336,
                    77.33039999008179,
                    54.00303816795349,
                    67.01877136230469,
                    64.17459640502929,
                    63.30630438668387
                ],
                "lowHeartRateEvents": [
                    6,
                    4,
                    1,
                    10,
                    2,
                    8,
                    3
                ],
                "restingHeartRate": [
                    41,
                    39,
                    40,
                    36,
                    39,
                    39,
                    40
                ],
                "sleepHours": [
                    4.995833333333334,
                    7.967638888888889,
                    8.183194444444446,
                    7.486527777777777,
                    8.784027777777778,
                    8.274583333333334,
                    5.899583333333333
                ],
                "weight": [
                    59.35283838388506,
                    59.482237639038125,
                    59.6116368941912,
                    59.741036149344275,
                    59.99983465965042,
                    60.069869609503264,
                    60.13990455935611
                ],
                "generalFeeling": [
                    4,
                    3,
                    3,
                    3,
                    3.5,
                    4,
                    5
                ],
                "mood": [
                    4,
                    3,
                    4,
                    2,
                    3.5,
                    4,
                    4
                ],
                "energy": [
                    3,
                    2,
                    3,
                    2,
                    3.5,
                    4,
                    4
                ],
                "focus": [
                    4,
                    3,
                    3,
                    3,
                    3.5,
                    4,
                    4
                ],
                "vitality": [
                    3.75,
                    2.75,
                    3.25,
                    2.5,
                    3.5,
                    4,
                    4.25
                ]
            },
            "most_important_metrics_dict": {
                "dietaryCarbohydrates": {
                    "correlation": 0.5979887506911482,
                    "local_percentage_change": 0.7872473300688523,
                    "local_mean": 102.19690309252057,
                    "global_percentage_change": -0.15960520020438151,
                    "global_mean": 121.60582516380939,
                    "importance": 1
                },
                "dietaryProtein": {
                    "correlation": 0.4480687341934286,
                    "local_percentage_change": 1.426790507996896,
                    "local_mean": 84.67074067252022,
                    "global_percentage_change": -0.09030844977918251,
                    "global_mean": 93.0763187279989,
                    "importance": 0.7683905077831571
                },
                "caloricIntake": {
                    "correlation": 0.5475331838583376,
                    "local_percentage_change": 0.9014811372400999,
                    "local_mean": 1144.8758610316686,
                    "global_percentage_change": -0.11082507630275984,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.7280377188614378
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.5979887506911482,
                    "local_percentage_change": 0.7872473300688523,
                    "local_mean": 102.19690309252057,
                    "global_percentage_change": -0.15960520020438151,
                    "global_mean": 121.60582516380939,
                    "importance": 1,
                    "metric": "dietaryCarbohydrates"
                },
                {
                    "correlation": 0.4480687341934286,
                    "local_percentage_change": 1.426790507996896,
                    "local_mean": 84.67074067252022,
                    "global_percentage_change": -0.09030844977918251,
                    "global_mean": 93.0763187279989,
                    "importance": 0.7683905077831571,
                    "metric": "dietaryProtein"
                },
                {
                    "correlation": 0.5475331838583376,
                    "local_percentage_change": 0.9014811372400999,
                    "local_mean": 1144.8758610316686,
                    "global_percentage_change": -0.11082507630275984,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.7280377188614378,
                    "metric": "caloricIntake"
                }
            ],
            "most_important_preceding_data": {
                "dietaryCarbohydrates": [
                    136.03812789916992,
                    114.46500396728516,
                    0,
                    63.91829967498779,
                    59.29166793823242,
                    177.83512115478516,
                    163.8301010131836
                ],
                "dietaryProtein": [
                    103.93294143676758,
                    74.62081909179688,
                    0,
                    99.89609336853027,
                    20.685001373291016,
                    111.29000091552734,
                    182.27032852172852
                ],
                "caloricIntake": [
                    1652.0244750976562,
                    937.7634887695312,
                    0,
                    1121.7441864013672,
                    404.550048828125,
                    1947.1421203613281,
                    1950.9067077636719
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 97,
            "anomaly_value": 4,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.5780730897009974,
                "local_mean": 3.4642857142857144,
                "global_percentage_change": 0.20588797416464688,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-05-19T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-05-19T00:00:00.000Z",
                    "2020-05-18T00:00:00.000Z",
                    "2020-05-11T00:00:00.000Z",
                    "2020-05-09T00:00:00.000Z",
                    "2020-05-06T00:00:00.000Z",
                    "2020-05-05T00:00:00.000Z",
                    "2020-05-04T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    416.32199999999995,
                    179.66999999999993,
                    475.00299999999925,
                    500.5039999999985,
                    468.1350000000006,
                    571.0280000000006,
                    762.9290000000032
                ],
                "basalEnergyBurned": [
                    1505.602999999997,
                    1303.6570000000002,
                    1635.1429999999696,
                    1014.9239999999382,
                    1624.4799999999655,
                    1632.7779999999586,
                    1641.6999999999284
                ],
                "caloricIntake": [
                    937.7634887695312,
                    0,
                    1121.7441864013672,
                    404.550048828125,
                    1947.1421203613281,
                    1950.9067077636719,
                    2228.034881591797
                ],
                "dietaryCarbohydrates": [
                    114.46500396728516,
                    0,
                    63.91829967498779,
                    59.29166793823242,
                    177.83512115478516,
                    163.8301010131836,
                    235.17884826660156
                ],
                "dietaryFats": [
                    19.73299217224121,
                    0,
                    49.40999794006348,
                    9.753334999084473,
                    80.74243927001953,
                    61.02450370788574,
                    79.88094139099121
                ],
                "dietaryProtein": [
                    74.62081909179688,
                    0,
                    99.89609336853027,
                    20.685001373291016,
                    111.29000091552734,
                    182.27032852172852,
                    155.85837745666504
                ],
                "hrv": [
                    59.50112533569336,
                    77.33039999008179,
                    54.00303816795349,
                    67.01877136230469,
                    64.17459640502929,
                    63.30630438668387,
                    47.124498748779295
                ],
                "lowHeartRateEvents": [
                    4,
                    1,
                    10,
                    2,
                    8,
                    3,
                    2
                ],
                "restingHeartRate": [
                    39,
                    40,
                    36,
                    39,
                    39,
                    40,
                    44
                ],
                "sleepHours": [
                    7.967638888888889,
                    8.183194444444446,
                    7.486527777777777,
                    8.784027777777778,
                    8.274583333333334,
                    5.899583333333333,
                    5.604722222222222
                ],
                "weight": [
                    59.482237639038125,
                    59.6116368941912,
                    59.741036149344275,
                    59.99983465965042,
                    60.069869609503264,
                    60.13990455935611,
                    60.20993950920895
                ],
                "generalFeeling": [
                    3,
                    3,
                    3,
                    3.5,
                    4,
                    5,
                    4
                ],
                "mood": [
                    3,
                    4,
                    2,
                    3.5,
                    4,
                    4,
                    4
                ],
                "energy": [
                    2,
                    3,
                    2,
                    3.5,
                    4,
                    4,
                    4
                ],
                "focus": [
                    3,
                    3,
                    3,
                    3.5,
                    4,
                    4,
                    4
                ],
                "vitality": [
                    2.75,
                    3.25,
                    2.5,
                    3.5,
                    4,
                    4.25,
                    4
                ]
            },
            "most_important_metrics_dict": {
                "caloricIntake": {
                    "correlation": 0.5973994434742296,
                    "local_percentage_change": 6.02208819253529,
                    "local_mean": 1227.163061959403,
                    "global_percentage_change": -0.04691621238432164,
                    "global_mean": 1287.5710172653198,
                    "importance": 1
                },
                "dietaryCarbohydrates": {
                    "correlation": 0.6399955740981306,
                    "local_percentage_change": 5.69393626082297,
                    "local_mean": 116.3598631450108,
                    "global_percentage_change": -0.04313906847580695,
                    "global_mean": 121.60582516380939,
                    "importance": 0.9313769079940826
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.5973994434742296,
                    "local_percentage_change": 6.02208819253529,
                    "local_mean": 1227.163061959403,
                    "global_percentage_change": -0.04691621238432164,
                    "global_mean": 1287.5710172653198,
                    "importance": 1,
                    "metric": "caloricIntake"
                },
                {
                    "correlation": 0.6399955740981306,
                    "local_percentage_change": 5.69393626082297,
                    "local_mean": 116.3598631450108,
                    "global_percentage_change": -0.04313906847580695,
                    "global_mean": 121.60582516380939,
                    "importance": 0.9313769079940826,
                    "metric": "dietaryCarbohydrates"
                }
            ],
            "most_important_preceding_data": {
                "caloricIntake": [
                    937.7634887695312,
                    0,
                    1121.7441864013672,
                    404.550048828125,
                    1947.1421203613281,
                    1950.9067077636719,
                    2228.034881591797
                ],
                "dietaryCarbohydrates": [
                    114.46500396728516,
                    0,
                    63.91829967498779,
                    59.29166793823242,
                    177.83512115478516,
                    163.8301010131836,
                    235.17884826660156
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 83,
            "anomaly_value": 4,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.5999999999999996,
                "local_mean": 2.7857142857142856,
                "global_percentage_change": -0.030316886754201633,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-04-07T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-04-07T00:00:00.000Z",
                    "2020-04-06T00:00:00.000Z",
                    "2020-04-05T00:00:00.000Z",
                    "2020-03-25T00:00:00.000Z",
                    "2020-03-24T00:00:00.000Z",
                    "2020-03-20T00:00:00.000Z",
                    "2020-03-19T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    203.11900000000026,
                    503.525000000001,
                    271.61100000000044,
                    701.3740000000021,
                    221.7239999999999,
                    281.7600000000001,
                    291.3509999999997
                ],
                "basalEnergyBurned": [
                    1610.6620000000003,
                    1638.2619999999872,
                    1491.3869999999993,
                    1633.592999999947,
                    1631.619000000001,
                    1445.2520000000006,
                    1641.6499999999985
                ],
                "caloricIntake": [
                    0,
                    1168.163444519043,
                    0,
                    924.5869140625,
                    0,
                    1622.3000183105469,
                    1097.3999938964844
                ],
                "dietaryCarbohydrates": [
                    0,
                    113.66126728057861,
                    0,
                    115.40467071533203,
                    0,
                    152.01000440120697,
                    115.08710479736328
                ],
                "dietaryFats": [
                    0,
                    46.17834138870239,
                    0,
                    18.826688766479492,
                    0,
                    49.86999988555908,
                    32.6831111907959
                ],
                "dietaryProtein": [
                    0,
                    82.6804609298706,
                    0,
                    81.93943786621094,
                    0,
                    137.82999801635742,
                    82.60400390625
                ],
                "hrv": [
                    63.690592765808105,
                    67.69189238548279,
                    49.69196891784668,
                    65.97013419015067,
                    62.04572614034017,
                    64.01455561319987,
                    53.158002853393555
                ],
                "lowHeartRateEvents": [
                    5,
                    10,
                    3,
                    0,
                    3,
                    3,
                    3
                ],
                "restingHeartRate": [
                    35,
                    36,
                    35,
                    41,
                    40,
                    40,
                    38
                ],
                "sleepHours": [
                    8.752500000000001,
                    7.572777777777778,
                    7.5,
                    7.616111111111111,
                    6.158055555555556,
                    7.903194444444444,
                    7.820972222222222
                ],
                "weight": [
                    59.400189643902436,
                    59.500205460288626,
                    59.60022127667481,
                    59.76376271404343,
                    59.81827652649964,
                    59.872790338955845,
                    59.92730415141205
                ],
                "generalFeeling": [
                    2.5,
                    2,
                    3,
                    3,
                    3,
                    3,
                    4
                ],
                "mood": [
                    3,
                    3,
                    3,
                    3,
                    3,
                    3,
                    4
                ],
                "energy": [
                    2.5,
                    1,
                    2.5,
                    1,
                    3,
                    3,
                    4
                ],
                "focus": [
                    2.5,
                    2,
                    3,
                    2,
                    2,
                    3,
                    4
                ],
                "vitality": [
                    2.625,
                    2,
                    2.875,
                    2.25,
                    2.75,
                    3,
                    4
                ]
            },
            "most_important_metrics_dict": {
                "dietaryProtein": {
                    "correlation": 0.09918619207665608,
                    "local_percentage_change": 4.612036788880345,
                    "local_mean": 55.00770010266985,
                    "global_percentage_change": -0.40900434337738123,
                    "global_mean": 93.0763187279989,
                    "importance": 1
                },
                "caloricIntake": {
                    "correlation": 0.10272626645234453,
                    "local_percentage_change": 3.7908228519705,
                    "local_mean": 687.4929101126535,
                    "global_percentage_change": -0.46605437611292,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.9700177564045956
                },
                "dietaryCarbohydrates": {
                    "correlation": 0.08160168487352622,
                    "local_percentage_change": 3.522312035570825,
                    "local_mean": 70.88043531349727,
                    "global_percentage_change": -0.4171296052798652,
                    "global_mean": 121.60582516380939,
                    "importance": 0.6408052586158249
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.09918619207665608,
                    "local_percentage_change": 4.612036788880345,
                    "local_mean": 55.00770010266985,
                    "global_percentage_change": -0.40900434337738123,
                    "global_mean": 93.0763187279989,
                    "importance": 1,
                    "metric": "dietaryProtein"
                },
                {
                    "correlation": 0.10272626645234453,
                    "local_percentage_change": 3.7908228519705,
                    "local_mean": 687.4929101126535,
                    "global_percentage_change": -0.46605437611292,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.9700177564045956,
                    "metric": "caloricIntake"
                },
                {
                    "correlation": 0.08160168487352622,
                    "local_percentage_change": 3.522312035570825,
                    "local_mean": 70.88043531349727,
                    "global_percentage_change": -0.4171296052798652,
                    "global_mean": 121.60582516380939,
                    "importance": 0.6408052586158249,
                    "metric": "dietaryCarbohydrates"
                }
            ],
            "most_important_preceding_data": {
                "dietaryProtein": [
                    0,
                    82.6804609298706,
                    0,
                    81.93943786621094,
                    0,
                    137.82999801635742,
                    82.60400390625
                ],
                "caloricIntake": [
                    0,
                    1168.163444519043,
                    0,
                    924.5869140625,
                    0,
                    1622.3000183105469,
                    1097.3999938964844
                ],
                "dietaryCarbohydrates": [
                    0,
                    113.66126728057861,
                    0,
                    115.40467071533203,
                    0,
                    152.01000440120697,
                    115.08710479736328
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 81,
            "anomaly_value": 4.75,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": 0.7172675521821628,
                "local_mean": 3.1964285714285716,
                "global_percentage_change": 0.11264921327562782,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-04-05T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-04-05T00:00:00.000Z",
                    "2020-03-25T00:00:00.000Z",
                    "2020-03-24T00:00:00.000Z",
                    "2020-03-20T00:00:00.000Z",
                    "2020-03-19T00:00:00.000Z",
                    "2020-03-18T00:00:00.000Z",
                    "2020-03-17T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    271.61100000000044,
                    701.3740000000021,
                    221.7239999999999,
                    281.7600000000001,
                    291.3509999999997,
                    324.18999999999977,
                    146.697
                ],
                "basalEnergyBurned": [
                    1491.3869999999993,
                    1633.592999999947,
                    1631.619000000001,
                    1445.2520000000006,
                    1641.6499999999985,
                    1652.4119999999998,
                    1620.7950000000014
                ],
                "caloricIntake": [
                    0,
                    924.5869140625,
                    0,
                    1622.3000183105469,
                    1097.3999938964844,
                    571.5409545898438,
                    516.3999633789062
                ],
                "dietaryCarbohydrates": [
                    0,
                    115.40467071533203,
                    0,
                    152.01000440120697,
                    115.08710479736328,
                    17.62221336364746,
                    48.011104583740234
                ],
                "dietaryFats": [
                    0,
                    18.826688766479492,
                    0,
                    49.86999988555908,
                    32.6831111907959,
                    20.688888549804688,
                    12.61111068725586
                ],
                "dietaryProtein": [
                    0,
                    81.93943786621094,
                    0,
                    137.82999801635742,
                    82.60400390625,
                    76.76666259765625,
                    52.29999923706055
                ],
                "hrv": [
                    49.69196891784668,
                    65.97013419015067,
                    62.04572614034017,
                    64.01455561319987,
                    53.158002853393555,
                    55.00180101394653,
                    72.35295333862305
                ],
                "lowHeartRateEvents": [
                    3,
                    0,
                    3,
                    3,
                    3,
                    3,
                    1
                ],
                "restingHeartRate": [
                    35,
                    41,
                    40,
                    40,
                    38,
                    39,
                    41
                ],
                "sleepHours": [
                    7.5,
                    7.616111111111111,
                    6.158055555555556,
                    7.903194444444444,
                    7.820972222222222,
                    8.315138888888889,
                    9.085277777777778
                ],
                "weight": [
                    59.60022127667481,
                    59.76376271404343,
                    59.81827652649964,
                    59.872790338955845,
                    59.92730415141205,
                    59.98181796386826,
                    60.03633177632447
                ],
                "generalFeeling": [
                    3,
                    3,
                    3,
                    3,
                    4,
                    3,
                    5
                ],
                "mood": [
                    3,
                    3,
                    3,
                    3,
                    4,
                    3,
                    5
                ],
                "energy": [
                    2.5,
                    1,
                    3,
                    3,
                    4,
                    3,
                    5
                ],
                "focus": [
                    3,
                    2,
                    2,
                    3,
                    4,
                    2,
                    4
                ],
                "vitality": [
                    2.875,
                    2.25,
                    2.75,
                    3,
                    4,
                    2.75,
                    4.75
                ]
            },
            "most_important_metrics_dict": {
                "activeEnergyBurned": {
                    "correlation": -0.6367389722637112,
                    "local_percentage_change": -0.52392259733294,
                    "local_mean": 319.81528571428595,
                    "global_percentage_change": -0.3472101531895003,
                    "global_mean": 489.9207413793096,
                    "importance": 1
                },
                "dietaryFats": {
                    "correlation": 0.09729886230213335,
                    "local_percentage_change": 1.4096511204665694,
                    "local_mean": 19.23997129712786,
                    "global_percentage_change": -0.5487552857463216,
                    "global_mean": 42.6375549438827,
                    "importance": 0.6497961600816198
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": -0.6367389722637112,
                    "local_percentage_change": -0.52392259733294,
                    "local_mean": 319.81528571428595,
                    "global_percentage_change": -0.3472101531895003,
                    "global_mean": 489.9207413793096,
                    "importance": 1,
                    "metric": "activeEnergyBurned"
                },
                {
                    "correlation": 0.09729886230213335,
                    "local_percentage_change": 1.4096511204665694,
                    "local_mean": 19.23997129712786,
                    "global_percentage_change": -0.5487552857463216,
                    "global_mean": 42.6375549438827,
                    "importance": 0.6497961600816198,
                    "metric": "dietaryFats"
                }
            ],
            "most_important_preceding_data": {
                "activeEnergyBurned": [
                    271.61100000000044,
                    701.3740000000021,
                    221.7239999999999,
                    281.7600000000001,
                    291.3509999999997,
                    324.18999999999977,
                    146.697
                ],
                "dietaryFats": [
                    0,
                    18.826688766479492,
                    0,
                    49.86999988555908,
                    32.6831111907959,
                    20.688888549804688,
                    12.61111068725586
                ]
            }
        },
        {
            "desired_metric": "vitality",
            "anomaly_index": 79,
            "anomaly_value": 1.5,
            "anomaly_metrics": {
                "correlation": 1,
                "local_percentage_change": -0.2275862068965515,
                "local_mean": 3.0595238095238093,
                "global_percentage_change": 0.06499384659901786,
                "global_mean": 2.872808908045977
            },
            "anomaly_start_of_date": "2020-03-24T00:00:00.000Z",
            "preceding_data": {
                "startOfDate": [
                    "2020-03-24T00:00:00.000Z",
                    "2020-03-20T00:00:00.000Z",
                    "2020-03-19T00:00:00.000Z",
                    "2020-03-18T00:00:00.000Z",
                    "2020-03-17T00:00:00.000Z",
                    "2020-03-13T00:00:00.000Z",
                    "2020-03-12T00:00:00.000Z"
                ],
                "activeEnergyBurned": [
                    221.7239999999999,
                    281.7600000000001,
                    291.3509999999997,
                    324.18999999999977,
                    146.697,
                    80.15599999999998,
                    214.77100000000004
                ],
                "basalEnergyBurned": [
                    1631.619000000001,
                    1445.2520000000006,
                    1641.6499999999985,
                    1652.4119999999998,
                    1620.7950000000014,
                    974.6330000000002,
                    1645.2489999999991
                ],
                "caloricIntake": [
                    0,
                    1622.3000183105469,
                    1097.3999938964844,
                    571.5409545898438,
                    516.3999633789062,
                    511,
                    0
                ],
                "dietaryCarbohydrates": [
                    0,
                    152.01000440120697,
                    115.08710479736328,
                    17.62221336364746,
                    48.011104583740234,
                    46.70000076293945,
                    0
                ],
                "dietaryFats": [
                    0,
                    49.86999988555908,
                    32.6831111907959,
                    20.688888549804688,
                    12.61111068725586,
                    15.999999046325684,
                    0
                ],
                "dietaryProtein": [
                    0,
                    137.82999801635742,
                    82.60400390625,
                    76.76666259765625,
                    52.29999923706055,
                    41.84000015258789,
                    0
                ],
                "hrv": [
                    62.04572614034017,
                    64.01455561319987,
                    53.158002853393555,
                    55.00180101394653,
                    72.35295333862305,
                    59.4730339050293,
                    66.67010158962674
                ],
                "lowHeartRateEvents": [
                    3,
                    3,
                    3,
                    3,
                    1,
                    8,
                    2
                ],
                "restingHeartRate": [
                    40,
                    40,
                    38,
                    39,
                    41,
                    39,
                    40
                ],
                "sleepHours": [
                    6.158055555555556,
                    7.903194444444444,
                    7.820972222222222,
                    8.315138888888889,
                    9.085277777777778,
                    10.1875,
                    8.316944444444445
                ],
                "weight": [
                    59.81827652649964,
                    59.872790338955845,
                    59.92730415141205,
                    59.98181796386826,
                    60.03633177632447,
                    60.090845588780674,
                    60.14535940123688
                ],
                "generalFeeling": [
                    3,
                    3,
                    4,
                    3,
                    5,
                    2.333333333333333,
                    1
                ],
                "mood": [
                    3,
                    3,
                    4,
                    3,
                    5,
                    3,
                    2
                ],
                "energy": [
                    3,
                    3,
                    4,
                    3,
                    5,
                    2.333333333333333,
                    1
                ],
                "focus": [
                    2,
                    3,
                    4,
                    2,
                    4,
                    3,
                    2
                ],
                "vitality": [
                    2.75,
                    3,
                    4,
                    2.75,
                    4.75,
                    2.666666666666666,
                    1.5
                ]
            },
            "most_important_metrics_dict": {
                "dietaryCarbohydrates": {
                    "correlation": 0.4272267431851129,
                    "local_percentage_change": -0.7087668647818235,
                    "local_mean": 54.2043468441282,
                    "global_percentage_change": -0.5542619214900921,
                    "global_mean": 121.60582516380939,
                    "importance": 1
                },
                "caloricIntake": {
                    "correlation": 0.3935424796978564,
                    "local_percentage_change": -0.6549099500336831,
                    "local_mean": 616.9487043108259,
                    "global_percentage_change": -0.5208429701833712,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.7998400268301771
                },
                "dietaryFats": {
                    "correlation": 0.3256772690127767,
                    "local_percentage_change": -0.6662111016330758,
                    "local_mean": 18.83615847996303,
                    "global_percentage_change": -0.5582261106493047,
                    "global_mean": 42.6375549438827,
                    "importance": 0.7216599104562881
                },
                "dietaryProtein": {
                    "correlation": 0.3850541914607293,
                    "local_percentage_change": -0.5974801743639133,
                    "local_mean": 55.905809129987446,
                    "global_percentage_change": -0.3993551754731136,
                    "global_mean": 93.0763187279989,
                    "importance": 0.547428989407545
                }
            },
            "most_important_metrics_array": [
                {
                    "correlation": 0.4272267431851129,
                    "local_percentage_change": -0.7087668647818235,
                    "local_mean": 54.2043468441282,
                    "global_percentage_change": -0.5542619214900921,
                    "global_mean": 121.60582516380939,
                    "importance": 1,
                    "metric": "dietaryCarbohydrates"
                },
                {
                    "correlation": 0.3935424796978564,
                    "local_percentage_change": -0.6549099500336831,
                    "local_mean": 616.9487043108259,
                    "global_percentage_change": -0.5208429701833712,
                    "global_mean": 1287.5710172653198,
                    "importance": 0.7998400268301771,
                    "metric": "caloricIntake"
                },
                {
                    "correlation": 0.3256772690127767,
                    "local_percentage_change": -0.6662111016330758,
                    "local_mean": 18.83615847996303,
                    "global_percentage_change": -0.5582261106493047,
                    "global_mean": 42.6375549438827,
                    "importance": 0.7216599104562881,
                    "metric": "dietaryFats"
                },
                {
                    "correlation": 0.3850541914607293,
                    "local_percentage_change": -0.5974801743639133,
                    "local_mean": 55.905809129987446,
                    "global_percentage_change": -0.3993551754731136,
                    "global_mean": 93.0763187279989,
                    "importance": 0.547428989407545,
                    "metric": "dietaryProtein"
                }
            ],
            "most_important_preceding_data": {
                "dietaryCarbohydrates": [
                    0,
                    152.01000440120697,
                    115.08710479736328,
                    17.62221336364746,
                    48.011104583740234,
                    46.70000076293945,
                    0
                ],
                "caloricIntake": [
                    0,
                    1622.3000183105469,
                    1097.3999938964844,
                    571.5409545898438,
                    516.3999633789062,
                    511,
                    0
                ],
                "dietaryFats": [
                    0,
                    49.86999988555908,
                    32.6831111907959,
                    20.688888549804688,
                    12.61111068725586,
                    15.999999046325684,
                    0
                ],
                "dietaryProtein": [
                    0,
                    137.82999801635742,
                    82.60400390625,
                    76.76666259765625,
                    52.29999923706055,
                    41.84000015258789,
                    0
                ]
            }
        }
    ]
}
"""

//var _sampleInsights: [YPDInsight] {
//    let sampleInsightsJson = JSON(parseJSON: sampleInsightsJsonString)["result"]
//    return sampleInsightsJson.arrayValue.map(YPDInsight.init(json:))
//}

//var _sampleInsights: [YPDInsight] {
//    return [YPDInsight(metricOfInterestType: .generalFeeling, metricOfInterestValue: 2.342, metricOfInterestGlobalChange: 0.34, metricOfInterestGlobalMean: 3,metricOfInterestLocalChange: 1.82, metricOfInterestLocalMean: 2, date: Date(),  mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .caloricIntake, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .dietaryCarbohydrates, localChange: -0.83, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .lowHeartRateEvents, localChange: 0.33, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .sleepHours, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: [])])]
//}

var _sampleInsights = Array.init(repeating: YPDInsight(metricOfInterestType: .generalFeeling, metricOfInterestValue: 2.342, metricOfInterestGlobalChange: 0.34, metricOfInterestGlobalMean: 3,metricOfInterestLocalChange: 1.82, metricOfInterestLocalMean: 2, date: Date(),  mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .caloricIntake, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .dietaryCarbohydrates, localChange: -0.83, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .lowHeartRateEvents, localChange: 0.33, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .sleepHours, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: [])]), count: 5)
