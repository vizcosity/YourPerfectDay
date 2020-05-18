//
//  StaticData.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

let _sampleMetricLog = MetricLog(metrics: [MetricAttribute(name: "Mood", value: 3)], timeSince: "2 Hours Ago")
let _sampleMetricLogs: [MetricLog] = {
    var output: [MetricLog] = []
    for _ in 0..<10 {
        output.append(_sampleMetricLog)
    }
    return output
}()
