//
//  Slider+YPD.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 05/12/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

extension Slider {
    init(value: Binding<Double>, in bounds: ClosedRange<Double>, step: Double, minimumValueLabel: ValueLabel, maximumValueLabel: ValueLabel, label: () -> Label){
        self.init(value: .init(get: { Float(value.wrappedValue) }, set: { value.wrappedValue = Double($0) }), in: Float(bounds.lowerBound)...Float(bounds.upperBound), step: Float(step), minimumValueLabel: minimumValueLabel, maximumValueLabel: maximumValueLabel, label: label)
    }
}
