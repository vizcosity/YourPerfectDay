//
//  Sample.swift
//  Benson
//
//  Created by Aaron Baw on 29/02/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation


extension Array {
    
    /// Returns numPoints even spread elements from the array, if numPoints is 0 < numPoints < array length.
    /// Returns an array of size floor(count / numPoints)
    public func sample(withAroundNumberOfPoints numPoints: Int) -> Self {
        
        if numPoints < 0 || numPoints > self.count { return self }
        
        let spacingBetweenElements = Int(self.count / numPoints)
        
        return self.enumerated().compactMap { $0.0 % spacingBetweenElements == 0 ? $0.1 : nil }
    }
}
