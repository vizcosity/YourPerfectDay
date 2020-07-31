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
    
    /// Limit for the number of anomalies which should be displayed.
    var anomalyMetricLimit: Int?
    var getAnomalyMetricLimit: Int {
        return self.anomalyMetricLimit != nil ? min(self.anomalyMetricLimit!, self.insight.mostImportantAnomalyMetrics.count) :  self.insight.mostImportantAnomalyMetrics.count
    }
    
    var increasedOrDecreasedString: String {
        return self.insight.metricOfInterestLocalChange > 0.0 ? "increased" : "decreased"
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
        
        _ = decimalFormatter.string(from: NSNumber(value: startValue))!
        _ = decimalFormatter.string(from: NSNumber(value: endValue))!
        
        _ = formatter.string(from: NSNumber(value: percentageMOIChange*100))!
        
        //        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "increased" : "decreased") by \(formattedPercentageMOIChange ?? "0")%, going from a global average of \(formattedStartValue) to \(formattedEndValue) during this period"
        
        
        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "increased" : "decreased") by \(self.insight.metricOfInterestLocalChange.formattedAsPercentage)"
        
    }
    
    var body: some View {
        YPDCardView(aboveFold: {EmptyView()}, mainContent: {
            VStack(alignment: .leading) {
                
                Text("\(self.insight.metricOfInterestLocalChange > 0.0 ? "Improved": "Declining") \(self.insight.metricOfInterestType.humanReadable)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                // Text notifying the user of the time period.
                Text("Your \(self.insight.metricOfInterestType.humanReadable) has \(self.increasedOrDecreasedString) over the last \(self.insight.timePeriod).")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    //                    Spacer()
                    .padding(.top, 5)
                
                YPDInsightProgressBarView(percentageMOIChangeValue: self.insight.metricOfInterestLocalChange)
                
                Text("\(self.briefMOISummarySentence). \nHere are some other changes:")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, CGFloat(10.0))
                    .fixedSize(horizontal: false, vertical: true)
                
                // Display each of the insights associated with the most important and correlated metrics.
                // CHECKPOINT. Investigating index of out bounds error.
                ForEach(self.insight.mostImportantAnomalyMetrics.prefix(self.getAnomalyMetricLimit), id: \.id) { anomalyMetric -> YPDSummaryIndividualMetricInsightView in
                    
                    // Embed in a HStack so that the results are all left-aligned.
                    return YPDSummaryIndividualMetricInsightView(metricName: anomalyMetric.metricAttribute.humanReadable, percentageChangeValue: anomalyMetric.localChange, timePeriod: anomalyMetric.timePeriod)
                    
                    
                }
                
            }
            //            .padding(.all, CGFloat(20.0))
        }, belowFold: {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text(self.insight.abbreviatedDateString)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                    Text("(\(self.insight.humanReadableDate))")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    NavigationLink(destination: YPDExpandedInsightView(insight: self.insight) ) {
                        HStack {
                            Text("More Detail")
                                .font(.caption)
                            Image(systemName: "chevron.right")
                                .scaleEffect(0.7)
                        }.foregroundColor(Color.gray)
                    }
                }
            }.padding(.top, 5)
                .padding(.bottom, -5)
        })
    }
    
}

struct YPDInsightSummaryViewLegacy: View {
    
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
    
    /// Limit for the number of anomalies which should be displayed.
    var anomalyMetricLimit: Int?
    var getAnomalyMetricLimit: Int {
        return self.anomalyMetricLimit != nil ? min(self.anomalyMetricLimit!, self.insight.mostImportantAnomalyMetrics.count) :  self.insight.mostImportantAnomalyMetrics.count
    }
    
    var increasedOrDecreasedString: String {
        return self.insight.metricOfInterestLocalChange > 0.0 ? "increased" : "decreased"
    }
    
    var body: some View {
        VStack {
            
            // Card above-fold content.
            VStack(alignment: .leading) {
                
                Text("\(self.insight.metricOfInterestLocalChange > 0.0 ? "Improved": "Declining") \(self.insight.metricOfInterestType.humanReadable)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                // Text notifying the user of the time period.
                Text("Your \(self.insight.metricOfInterestType.humanReadable) has \(self.increasedOrDecreasedString) over the last \(self.insight.timePeriod).")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    //                    Spacer()
                    .padding(.top, 5)
                
                YPDInsightProgressBarView(percentageMOIChangeValue: self.insight.metricOfInterestLocalChange)
                
                Text("\(self.briefMOISummarySentence). \nHere are some other changes:")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, CGFloat(10.0))
                    .fixedSize(horizontal: false, vertical: true)
                
                // Display each of the insights associated with the most important and correlated metrics.
                // CHECKPOINT. Investigating index of out bounds error.
                ForEach(self.insight.mostImportantAnomalyMetrics.prefix(self.getAnomalyMetricLimit), id: \.id) { anomalyMetric -> YPDSummaryIndividualMetricInsightView in
                    
                    // Embed in a HStack so that the results are all left-aligned.
                    return YPDSummaryIndividualMetricInsightView(metricName: anomalyMetric.metricAttribute.humanReadable, percentageChangeValue: anomalyMetric.localChange, timePeriod: anomalyMetric.timePeriod)
                    
                    
                }
                
            }
            .padding(.all, CGFloat(20.0))
            
            // Card below-fold content. (More Detail indicator)
            VStack {
                Rectangle()
                    .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
                    .frame(width: nil, height: 1, alignment: .center)
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text(self.insight.abbreviatedDateString)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                    Text("(\(self.insight.humanReadableDate))")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    HStack {
                        Text("More Detail")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .scaleEffect(0.7)
                    }.foregroundColor(Color.gray)
                }
                .padding(.all, CGFloat(5))
                .padding([.trailing, .leading], CGFloat(10))
                .padding(.bottom, CGFloat(5))
            }
        }
        .background(Color.white)
        .cornerRadius(6.0)
        .shadow(color: Color.init(red: 0.9, green: 0.9, blue: 0.9), radius: 10, x: 0, y: 10)
        .padding([.leading, .top, .trailing], 10)
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
        
        _ = decimalFormatter.string(from: NSNumber(value: startValue))!
        _ = decimalFormatter.string(from: NSNumber(value: endValue))!
        
        _ = formatter.string(from: NSNumber(value: percentageMOIChange*100))!
        
        //        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "increased" : "decreased") by \(formattedPercentageMOIChange ?? "0")%, going from a global average of \(formattedStartValue) to \(formattedEndValue) during this period"
        
        
        return "Your \(metricOfInterest) has \(percentageMOIChange > 0 ? "increased" : "decreased") by \(self.insight.metricOfInterestLocalChange.formattedAsPercentage)"
        
    }
}

struct YPDInsightSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            YPDInsightSummaryView(insight: YPDInsight(metricOfInterestType: .generalFeeling, metricOfInterestValue: 2.342, metricOfInterestGlobalChange: 0.34, metricOfInterestGlobalMean: 3,metricOfInterestLocalChange: 1.82, metricOfInterestLocalMean: 2, date: Date(timeIntervalSinceNow: -199999),  mostImportantAnomalyMetrics: [YPDAnomalyMetric(metricAttribute: .caloricIntake, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .dietaryCarbohydrates, localChange: -0.83, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .lowHeartRateEvents, localChange: 0.33, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: []), YPDAnomalyMetric(metricAttribute: .sleepHours, localChange: -0.23, localMean: 1400, globalChange: -0.11, globalMean: 2000, correlation: 0.45, importance: 0.8, timePeriod: "this week", precedingData: [])]), anomalyMetricLimit: 2)
            //        YPDInsightSummaryView(insight: _sampleInsights[0])
        }
    }
}
