//
//  AggregationCriteria.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 17/10/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

/// Enum describing the different aggregation criterias that can be used to collected aggregated health and checkin data.
enum AggregationCriteria: String, CustomStringConvertible, CaseIterable {
    case day
    case week
    case month
    case quarter
    case year

    var description: String {
        return self.rawValue
    }

    var calendarComponent: Calendar.Component {
        switch self {
            case .day: return .day
            case .week: return .weekOfMonth
            case .month: return .month
            case .quarter: return .quarter
            case .year: return .year
        }
    }
    
    /// Returns the maximum number of data points that should be displayed to the user when the given aggregation criteria is selected.
    var maxNumberOfPoints: Int {
        switch self {
        case .day: return 30 // Two Weeks.
        case .week: return 16 // Two Months.
        case .month: return 12 // Six Months.
        case .quarter: return 16 // Two years.
        case .year: return 10 // Last Decade.
        }
    }
    
    var humanReadable: String {
        return self.description.prefix(1).capitalized + "\(self.description.dropFirst(1))"
    }
}
