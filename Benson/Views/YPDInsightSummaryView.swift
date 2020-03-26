//
//  YPDInsightSummaryView.swift
//  
//
//  Created by Aaron Baw on 26/03/2020.
//

import SwiftUI

struct YPDInsightSummaryView: View {
    
    /// The metric which we shall be attempting to explain through the use of the following insights.
    var metricOfInterest: String
    /// The percentage change for the metricOfInterest
    var percentageMOIChange: Double
    
    var briefMOISummarySentence: String {
        return self.provideBriefMOISummarySentence(metricOfInterest: metricOfInterest, percentageMOIChange: percentageMOIChange)
    
    var body: some View {
        VStack {
            HStack {
                Text(self.briefMOISummarySentence)
                Spacer()
            }
        }
    }
    
    /// Given the metric of interest and the percentage change, provides a short summary sentence.
    func provideBriefMOISummarySentence(metricOfInterest: String, percentageMOIChange: Double) -> String {
        
        // Format the percentageMOIChange as a percentage with no decimal places.
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        
        let formattedPercentageMOIChange = formatter.formatter.string(from: NSNumber(percentageMOIChange))
        
        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "improved" : "fallen") \(formattedPercentageMOIChange)"
        
    }
}

struct YPDInsightSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightSummaryView(metricOfInterest: "Vitality", percentageMOIChange: 0.33)
    }
}
