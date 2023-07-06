//
//  YPDExpandedInsightView.swift
//  Benson
//
//  Created by Aaron Baw on 19/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDExpandedInsightView: View {
    
    var insight: YPDInsight
    
    var displayedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: self.insight.date)
    }
    
    
    var body: some View {
        
        BackgroundViewWrapper {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text("\(self.displayedDateString)").font(.title)
                            .fontWeight(.bold)
                        Text("Some more detailed information on your \(self.insight.metricOfInterestType.humanReadable).").foregroundColor(.gray)
                    }.padding([.leading, .trailing, .bottom], Constants.Padding)
                    
                    YPDAnomalyInsightHeaderView(insight: self.insight)
                    
                    ForEach(self.insight.mostImportantAnomalyMetrics, id: \.id) { anomalyMetric in
                        
                        VStack {
                            YPDIndividualMetricInsightView(anomalyMetric: anomalyMetric)
                            
                            // Use a YPDChartView instead of the OCKCartersianChartView
                            YPDChartView(chartData: YPDChartData(multipleSeries: [anomalyMetric.precedingData], attributes: [anomalyMetric.metricAttribute])).padding([.trailing, .leading], 10)
                            
                            
                            // We assume that the aggregation criteria is always on a day-basis for the anomaly metric. (This will need to be udpated in the future to support weekly, as well as monthly aggregation.
//                            OCKCartesianChartViewWrapper(chartData: YPDChartData(multipleSeries: [anomalyMetric.precedingData], attributes: [anomalyMetric.metricAttribute]))
//                                .frame(width: nil, height: 300, alignment: .center)
//                                .padding([.leading, .trailing], Constants.Padding)
                        }
                        
                    }
                    
                }
            }
        }
    }
}

struct YPDAnomalyInsightHeaderView: View {
    
    var increasedOrDecreasedString: String {
        return self.insight.metricOfInterestLocalChange > 0.0 ? "increased" : "decreased"
    }
    
    var insight: YPDInsight
    
    var body: some View {
        YPDCardView<EmptyView, AnyView, AnyView>(mainContent: {
            AnyView(VStack(alignment: .leading) {
                
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
                
                Text("Below are some changes which may be related.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
            })
            
        }, belowFold: {
            AnyView(HStack {
                Image(systemName: "calendar")
                Text("\(self.insight.abbreviatedDateString)")
                Spacer()
            }.foregroundColor(.gray)
                .font(.caption)
                .padding(.bottom, -5))
        })
    }
}


struct YPDExpandedInsightView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundViewWrapper {
            YPDExpandedInsightView(insight: _sampleInsights[0])
        }
    }
}

struct YPDIndividualMetricInsightView: View {
    
    var anomalyMetric: YPDAnomalyMetric
    
    var body: some View {
        
        YPDCardView<EmptyView, AnyView, EmptyView>(mainContent: {
            
            AnyView(VStack(alignment: .leading) {
                
                HStack<TupleView<(YPDSummaryIndividualMetricInsightView, Spacer)>> {
                    YPDSummaryIndividualMetricInsightView(metricName: self.anomalyMetric.metricAttribute.humanReadable, percentageChangeValue: self.anomalyMetric.localChange, timePeriod: self.anomalyMetric.timePeriod)
                    Spacer()
                }
                
                Text(self.anomalyMetric.changeOverLocalPeriodDescription ?? "")
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray)
                    .padding(.top, self.anomalyMetric.changeOverLocalPeriodDescription != nil ? Constants.Padding : 0)
                
                Text(self.anomalyMetric.changeOverGlobalPeriodDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, self.anomalyMetric.changeOverLocalPeriodDescription != nil ? Constants.Padding : 0)
                    .padding(.bottom, -Constants.Padding)
                
                
                Text(self.anomalyMetric.correlationToAffectingMetricAttributeDescription != nil ? self.anomalyMetric.correlationToAffectingMetricAttributeDescription! : "")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, self.anomalyMetric.correlationToAffectingMetricAttributeDescription != nil ? Constants.Padding : 0)
                
                
            })
            
            
            
        }, belowFold: {
            EmptyView()
        }, hideBelowFoldSeparator: true)
        
        
    }
}
