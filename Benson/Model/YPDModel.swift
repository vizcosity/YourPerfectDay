//
//  YPDModel.swift
//  YourPerfectDay
//
//  The YPD Model file contains a singleton object which is shared across all views, containing the available
//  checkin prompts which are displayed to the user.
//
//  Created by Aaron Baw on 20/06/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Singleton object containing YPDCheckinPrompts.
class YPDModel: ObservableObject {
    
    static let shared = YPDModel()
    
    /// Checkin prompt values for each slider.
    @Published var sliderValues: [Float] = [0]
    
    @Published var checkinPrompts: [YPDCheckinPrompt] = []
    
    init() {
        Fetcher.sharedInstance.fetchMetricPrompts(completionHandler: {
            self.checkinPrompts = $0
            self.sliderValues = Array.init(repeating: 0, count: self.checkinPrompts.count)
            
        })
    }
    
    func log(_ msg: String...){
        print("YPDModel |", msg)
    }
    
}
