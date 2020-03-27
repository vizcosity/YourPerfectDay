//
//  YPDInsightSummaryVIEWProgressBar.swift
//  Benson
//
//  Created by Aaron Baw on 27/03/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDInsightProgressBarView: View {
    
    let _defaultProgressBarHeight: CGFloat = 10
    let _defaultCornerRadius: CGFloat = 4
    
    var percentageMOIChangeValue: Double
    
    var percentageMOIChange: String {
        let formatter = NumberFormatter()
         formatter.numberStyle = .percent
         formatter.minimumIntegerDigits = 2
         formatter.maximumIntegerDigits = 2
         formatter.maximumFractionDigits = 0
         
        let formattedPercentageMOIChange = formatter.string(from: NSNumber(value: self.percentageMOIChangeValue))
        
        return formattedPercentageMOIChange ?? "0%"
    }
    
    var body: some View {
        
        // Add a ZStack since we will be layering shapes ontop of other shapes.
//        ZStack {
            
            GeometryReader { geometry in
                
                
            
            // Above-background progress bar - the colour once again depends on whether or not the MOI has increased or decreased. This is always positioned to fill half of the progress bar by default.
            Rectangle()
                .fill(self.percentageMOIChangeValue >= 0 ? Color.green : Color.red)
                .frame(width: self.percentageMOIChangeValue >= 0 ? geometry.size.width * 0.5 : ((geometry.size.width * 0.5) + (geometry.size.width * 0.5)*CGFloat(self.percentageMOIChangeValue)), height: self._defaultProgressBarHeight, alignment: .leading)
                .cornerRadius(self._defaultCornerRadius)
                .zIndex(2)
                
                
            Text(self.percentageMOIChange)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.85))
                .scaleEffect(0.6)
                .position(x: (geometry.size.width * 0.5) + (0.5) * (geometry.size.width * 0.5)*CGFloat(self.percentageMOIChangeValue), y: self._defaultProgressBarHeight * 0.5)
                .zIndex(3)
                
            
            // Intermediary progress bar - this shows the relative change in the MOI, using a neutral colour.
            Rectangle()
                .fill(Color.blue)
                .frame(width: self.percentageMOIChangeValue >= 0 ? ((geometry.size.width * 0.5) + (geometry.size.width * 0.5)*CGFloat(self.percentageMOIChangeValue)) : 0.5*geometry.size.width, height: self._defaultProgressBarHeight)
                .cornerRadius(self._defaultCornerRadius)
                .zIndex(1)
               

                
                
            
            // Background progress bar - the colour depends on whether the MOI has increased, or decreased.
            Rectangle()
                .fill(self.percentageMOIChangeValue >= 0.5 ? Color.green.opacity(0.8) : Color.red.opacity(0.8))
                .frame(width: geometry.size.width, height: self._defaultProgressBarHeight, alignment: .center)
                .cornerRadius(self._defaultCornerRadius)
                .zIndex(0)
            }
            .frame(height: self._defaultProgressBarHeight)
        }
//    }
}

struct YPDInsightSummaryVIEWProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightProgressBarView(percentageMOIChangeValue: 0.64)
    }
}
