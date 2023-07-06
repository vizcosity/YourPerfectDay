//
//  YPDAggregatedHealthAndCheckinData.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 09/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import Foundation

import Foundation

// MARK: - YPDAggregatedHealthAndCheckinDataResponse
struct YPDAggregatedHealthAndCheckinDataResponse: Codable {
    let success: Bool
    let result: [YPDAggregatedHealthAndCheckinDataObject]
}

// MARK: - YPDAggregatedHealthAndCheckinDataObject
struct YPDAggregatedHealthAndCheckinDataObject: Codable {
    let generalFeeling, mood, focus, energy: Double?
    let startOfDate: Date
    let activeEnergyBurned, basalEnergyBurned, caloricIntake, dietaryCarbohydrates: Double
    let dietaryFats, dietaryProtein, exerciseMinutes, hrv: Double
    let lowHeartRateEvents, restingHeartRate, sleepHours, standingMinutes: Double
    let stepCount, weight: Double
    let attributesAndCounts: [String: Int]

    subscript(_ key: YPDCheckinType) -> Double? {
        get {
            switch key {
            case .activeEnergyBurned: return activeEnergyBurned
            case .basalEnergyBurned: return basalEnergyBurned
            case .caloricIntake: return caloricIntake
            case .dietaryCarbohydrates: return dietaryCarbohydrates
            case .dietaryFats: return dietaryFats
            case .dietaryProtein: return dietaryProtein
            case .energy: return energy
            case .exerciseMinutes: return exerciseMinutes
            case .focus: return focus
            case .generalFeeling: return generalFeeling
            case .hrv: return hrv
            case .lowHeartRateEvents: return lowHeartRateEvents
            case .mood: return mood
            case .restingHeartRate: return restingHeartRate
            case .sleepHours: return sleepHours
            case .standingMinutes: return standingMinutes
            case .stepCount: return stepCount
            default: return nil
            }
        }
    }
}
