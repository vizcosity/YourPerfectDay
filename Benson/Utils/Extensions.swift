//
//  Extensions.swift
//  Benson
//
//  Created by Aaron Baw on 29/03/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

extension Double {
    
    /// Displays the double value as a formatted percentage, rounded to two significant figures and no decimal places.
    /// Returns: - "0%" if unable to format.
    var formattedAsPercentage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        
       let formattedPercentage = formatter.string(from: NSNumber(value: self))
       
       return formattedPercentage ?? "0%"
    }
}
