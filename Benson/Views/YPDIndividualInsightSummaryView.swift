//
//  YPDInsightSummaryView.swift
//  The Insight Summary View displays the change in the metric of interest, alongside the changes in the most important metrics which are believed to be related to this change.
//  Created by Aaron Baw on 26/03/2020.
//

import SwiftUI

struct YPDInsightSummaryView: View {
    
//    /// The metric which the following insight pertains to.
//    var metricOfInterest: String
//
//    /// The percentage change for the metricOfInterest
//    var percentageMOIChange: Double
    
    // Brief MetricOfInterestSummary Sentence.
    var briefMOISummarySentence: String {
        return self.provideBriefMOISummarySentence(metricOfInterest: self.insight.metricOfInterestType.humanReadable, percentageMOIChange: self.insight.metricOfInterestLocalChange, startValue: self.insight.metricOfInterestGlobalMean, endValue: self.insight.metricOfInterestValue)
    }
    
    var insight: YPDInsight
    
    var body: some View {
        VStack {
            
            // Card above-fold content.
            VStack {
                
                HStack {
                    Text("\(self.insight.metricOfInterestLocalChange > 0.0 ? "Improved": "Declining") \(self.insight.metricOfInterestType.humanReadable)")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                // Text notifying the user of the time period.
                HStack {
                    Text("Your \(self.insight.metricOfInterestType.humanReadable) over the last \(self.insight.timePeriod).")
                        .font(.subheadline)
                    Spacer()
                }.padding(.top, 5)
                
                YPDInsightProgressBarView(percentageMOIChangeValue: self.insight.metricOfInterestLocalChange)
                
                HStack {
                    Text("\(self.briefMOISummarySentence). Here are some other changes:")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.bottom, CGFloat(10.0))
                
                // Display each of the insights associated with the most important and correlated metrics.
                ForEach(0..<self.insight.mostImportantAnomalyMetrics.count) {

                    // Embed in a HStack so that the results are all left-aligned.
                    YPDSummaryIndividualMetricInsightView(metricName: self.insight.mostImportantAnomalyMetrics[$0].metricAttribute.humanReadable, percentageChangeValue: self.insight.mostImportantAnomalyMetrics[$0].localChange, timePeriod: self.insight.mostImportantAnomalyMetrics[$0].timePeriod ?? self.insight.timePeriod)
                    

                }
                                
            }
            .padding(.all, CGFloat(20.0))
            
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
                .padding(.all, CGFloat(5))
                .padding(.trailing, CGFloat(10))
                .padding(.bottom, CGFloat(5))
            }
        }
        .background(Color.white)
        .cornerRadius(6.0)
        .shadow(color: Color.init(red: 0.9, green: 0.9, blue: 0.9), radius: 10, x: 0, y: 10)
        .padding(.all, 10)
    }
    
    /// Given the metric of interest and the percentage change, provides a short summary sentence.
    func provideBriefMOISummarySentence(metricOfInterest: String, percentageMOIChange: Double, startValue: Double, endValue: Double) -> String {
        
        // Format the percentageMOIChange as a percentage with no decimal places.
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        
        let decimalFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        let formattedStartValue = decimalFormatter.string(from: NSNumber(value: startValue))!
        let formattedEndValue = decimalFormatter.string(from: NSNumber(value: endValue))!
        
        let formattedPercentageMOIChange = formatter.string(from: NSNumber(value: percentageMOIChange*100))!
        
        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "increased" : "decreased") by \(formattedPercentageMOIChange ?? "0")%, going from a global average of \(formattedStartValue) to \(formattedEndValue) during this period"
        
    }
}

struct YPDInsightSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightSummaryView(insight: YPDInsight(metricOfInterestType: .vitality, metricOfInterestValue: 2.342, metricOfInterestGlobalChange: 0.34, metricOfInterestGlobalMean: 3,metricOfInterestLocalChange: 1.22, metricOfInterestLocalMean: 2, date: Date(),  mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .caloricIntake, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: [])]))
    }
}
