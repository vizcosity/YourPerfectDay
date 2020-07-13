//
//  YPDInsightSummaryVIEWProgressBar.swift
//  Benson
//
//  Created by Aaron Baw on 27/03/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDBackgroundProgressBarView: View {
    
    var geometry: GeometryProxy
    var percentageMOIChangeValue: Double
    
    var body: some View {
        
        let colour = self.percentageMOIChangeValue >= 0 ? Colour.progresssBarGreen : Colour.progressBarRed
        
        // Background progress bar - the colour depends on whether the MOI has increased, or decreased.
        return Rectangle()
            .fill(colour.opacity(0.5))
            .frame(width: geometry.size.width, height: Constants.defaultProgressBarHeight, alignment: .center)
            .cornerRadius(ProgressBarDefaults.defaultCornerRadius)
            .zIndex(0)
    }
}

struct YPDIntermediaryProgressBarView: View {
    
    var geometry: GeometryProxy
    var percentageMOIChangeValue: Double

    var body: some View {
        let colour = self.percentageMOIChangeValue >= 0 ? Colour.progresssBarGreen : Colour.progressBarRed
       
        let widthIfIncreasing = max(0.5,(geometry.size.width * 0.5) + (geometry.size.width * 0.5)*CGFloat(self.percentageMOIChangeValue))
        
        let widthIfDecreasing = (self.percentageMOIChangeValue < -1 ? 0 : 0.5) * geometry.size.width
        
        let width = self.percentageMOIChangeValue >= 0 ? widthIfIncreasing : widthIfDecreasing
        return Rectangle()
            .fill(colour.opacity(0.3))
            .frame(width: width, height: ProgressBarDefaults.defaultProgressBarHeight)
            .cornerRadius(ProgressBarDefaults.defaultCornerRadius)
            .zIndex(1)
    }
}

struct YPDOverlayedProgressBarView: View {
    
    var geometry: GeometryProxy
    var percentageMOIChangeValue: Double

    var body: some View {
        
        let colour = self.percentageMOIChangeValue >= 0 ? Colour.progresssBarGreen : Colour.progressBarRed

        let widthIfIncreasing = geometry.size.width * (self.percentageMOIChangeValue <= 1 ? 0.5 : 1)
        
        let widthIfDecreasing = (geometry.size.width * 0.5) + ((geometry.size.width * 0.5) * CGFloat(self.percentageMOIChangeValue))
        
        let width = self.percentageMOIChangeValue >= 0 ? widthIfIncreasing : widthIfDecreasing
        
        // Above-background progress bar - the colour once again depends on whether or not the MOI has increased or decreased. This is always positioned to fill half of the progress bar by default.
        return Rectangle()
            .fill(colour)
            .frame(width: width, height: ProgressBarDefaults.defaultProgressBarHeight, alignment: .leading)
            .cornerRadius(ProgressBarDefaults.defaultCornerRadius)
            .zIndex(2)
    }
    
}

struct YPDProgressBarPercentage: View {
    var percentageMOIChangeValue: Double
    var geometry: GeometryProxy
    
    var halfWidth: CGFloat {
         self.geometry.size.width * 0.5
    }
    
    var textPositionX: CGFloat {
        (abs(self.percentageMOIChangeValue) < 1) ? self.halfWidth + (0.5) * self.halfWidth * CGFloat(self.percentageMOIChangeValue) : self.halfWidth
    }

    var textPositionY: CGFloat {
        ProgressBarDefaults.defaultProgressBarHeight * 0.5
    }
    
    
    
    var body: some View {
        Text(self.percentageMOIChangeValue.formattedAsPercentage)
        .font(.caption)
        .foregroundColor(Color.white.opacity(0.85))
        .scaleEffect(0.6)
            .position(x: self.textPositionX, y: self.textPositionY)
        .zIndex(3)
    }
}

struct YPDInsightProgressBarView: View {

    var percentageMOIChangeValue: Double
    
    var body: some View {
        
        // Add a ZStack since we will be layering shapes ontop of other shapes.
//        ZStack {
            
            GeometryReader { geometry in
                
                YPDOverlayedProgressBarView(geometry: geometry, percentageMOIChangeValue: self.percentageMOIChangeValue)
                
                YPDIntermediaryProgressBarView(geometry: geometry, percentageMOIChangeValue: self.percentageMOIChangeValue)
            
                YPDProgressBarPercentage(percentageMOIChangeValue: self.percentageMOIChangeValue, geometry: geometry)
                
                YPDBackgroundProgressBarView(geometry: geometry, percentageMOIChangeValue: self.percentageMOIChangeValue)
            
            }
            .frame(height: ProgressBarDefaults.defaultProgressBarHeight)
        }
//    }
}

struct ProgressBarDefaults {
    static let defaultProgressBarHeight: CGFloat = 10
    static let defaultCornerRadius: CGFloat = 5
}

struct YPDInsightSummaryVIEWProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightProgressBarView(percentageMOIChangeValue: 2.95)
    }
}
