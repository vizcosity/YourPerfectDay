//
//  Date+YPD.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 09/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var ypdDateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }
}
