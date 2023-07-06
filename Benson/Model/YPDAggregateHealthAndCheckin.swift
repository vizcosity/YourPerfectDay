//
//  YPDAggregateHealthAndCheckin.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 05/12/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

// MARK: - YPDAggregateHealthAndCheckinResponse
struct YPDAggregateResponse: Codable {
    let success: Bool
    let result: [YPDAggregate]
}

// MARK: - Result
struct YPDAggregate: Codable {
    let startOfDate: String
    let activeEnergyBurned, basalEnergyBurned, caloricIntake, dietaryCarbohydrates: Double
    let dietaryFats, dietaryProtein, exerciseMinutes, hrv: Double
    let lowHeartRateEvents, restingHeartRate, sleepHours, standingMinutes: Double
    let stepCount, weight, generalFeeling, mood: Double
    let energy, focus: Double
    let attributesAndCounts: [YPDCheckinType: Int]
}
