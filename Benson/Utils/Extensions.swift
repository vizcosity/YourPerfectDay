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

extension String {
    var capitalisingFirstLetter: String {
        return self.prefix(1).capitalized + self.dropFirst(1)
    }
}

extension Date {
    static func from(isoString: String) -> Date {
       let formatter = ISO8601DateFormatter()
       formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
       let parsedDate = formatter.date(from: isoString)
//       self.log("Attempting to parse \(unenrichedCheckinInfo.stringValue) as a date: \(String(describing: parsedDate))")
       return parsedDate!
    }
}

protocol PrettyPrintable: CustomStringConvertible {}
extension PrettyPrintable {
    var description: String {
         let mirror = Mirror(reflecting: self)
         
         var str = "\(mirror.subjectType)("
         var first = true
         for (label, value) in mirror.children {
           if let label = label {
             if first {
               first = false
             } else {
               str += ", "
             }
             str += label
             str += ": "
             str += "\(value)"
           }
         }
         str += ")"
         
         return str
       }
}
