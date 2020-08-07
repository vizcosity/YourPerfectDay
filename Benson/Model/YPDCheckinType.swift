//
//  YPDCheckinType.swift
//  Benson
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation


/// The measurement or metric type.
// TODO: Refactor so that the metric types are inferred from the keys of the aggregated healthDataObject, from the backend.
enum YPDCheckinType: String, CaseIterable, Hashable, Identifiable {
    
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
    
    // Unknown case, occurring when we fail to initialise via a string value.
    case unknown
    
    /// Returns human readable sentences describing the metric type, converting from camelCase to a sentence.
    var humanReadable: String {
        return self.rawValue.map { "\($0.isUppercase ? " \($0)" : "\($0)")" }.joined(separator: "").capitalized
    }
    
    var id: String {
        self.rawValue
    }
}
