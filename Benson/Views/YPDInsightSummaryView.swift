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
    
    var timePeriod: String = "this week"
    
    var briefMOISummarySentence: String {
        return self.provideBriefMOISummarySentence(metricOfInterest: self.metricOfInterest, percentageMOIChange: self.percentageMOIChange)
    }
    
    var body: some View {
        VStack {
            
            // Card above-fold content.
            VStack {
                HStack {
                    Text("\(self.percentageMOIChange > 0.0 ? "Improved": "Declining") \(metricOfInterest)")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                // Text notifying the user of the time period.
                HStack {
                    Text("\(self.metricOfInterest) \(self.timePeriod):")
                        .font(.caption)
                    Spacer()
                }
                
               YPDInsightProgressBarView(percentageMOIChangeValue: self.percentageMOIChange)
                
                HStack {
                    Text(self.briefMOISummarySentence)
                        .font(.caption)
                    Spacer()
                }
            }
            .padding(.all, 20.0)
            
            // Card below-fold content. (More Detail indicator)
            VStack {
                Rectangle()
                    .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
                    .frame(width: nil, height: 1, alignment: .center)
                HStack {
                    Spacer()
                    HStack {
                            Text("More Detail")
                                .font(.caption)
                            Image(systemName: "chevron.right")
                                .scaleEffect(0.7)
                    }.foregroundColor(Color.gray)
                }
                .padding(.all, 5)
                .padding(.bottom, 5)
            }
        }
        .background(Color.white)
        .cornerRadius(6.0)
        .shadow(color: Color.init(red: 0.9, green: 0.9, blue: 0.9), radius: 10, x: 0, y: 10)
        .padding(.all, 10)
    }
    
    /// Given the metric of interest and the percentage change, provides a short summary sentence.
    func provideBriefMOISummarySentence(metricOfInterest: String, percentageMOIChange: Double) -> String {
        
        // Format the percentageMOIChange as a percentage with no decimal places.
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        
        let formattedPercentageMOIChange = formatter.string(from: NSNumber(value: percentageMOIChange))
        
        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "improved" : "fallen") \(formattedPercentageMOIChange ?? "0%")"
        
    }
}

struct YPDInsightSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightSummaryView(metricOfInterest: "Vitality", percentageMOIChange: -0.16)
    }
}
