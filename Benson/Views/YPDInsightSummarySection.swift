//
//  YPDInsightSummarySection.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 15/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

/// Displays a single YPD insight, linking to the extended YPDInsightExpandedView.
struct YPDInsightSummarySection: View {
    
    var insight: YPDInsight?
    
    var insights: [YPDInsight]?

    
    // When the metric changes, the entire view should invalidate and request a new insight.
    var metric: YPDCheckinType? = .generalFeeling
    
    var aggregationCriteria: AggregationCriteria? = .day
    
//    func fetchInsight() -> Void {
//        if let metric = self.metric, let aggregationCriteria = self.aggregationCriteria {
//        Fetcher.sharedInstance.fetchInsights(forMetric: metric,  withAggregationCriteria: aggregationCriteria, limit: 1) {
//            if let firstInsight = $0.first {
//                withAnimation {
//                    self.insight = firstInsight
//                }
//            }
//        }
//        }
//    }
    @ViewBuilder
    var loadingView: some View {
        // Display an indeterminate progress bar.
        if #available(iOS 14.0, *) {
            ProgressView("Loading Insights")
                .padding(.top, Constants.Padding)
        } else {
            Text("Loading Insights")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if self.insight != nil && self.insights == nil {
                
                Text("Recent Insight")
                    .font(.headline)
                    .padding(.init([.top, .leading, .trailing]), Constants.Padding)
                
                YPDInsightSummaryView(insight: self.insight!, anomalyMetricLimit: 2)
                
            } else if self.insight == nil && self.insights != nil && !self.insights!.isEmpty {
                
                ForEach(self.insights!){
                    YPDInsightSummaryView(insight: $0, anomalyMetricLimit: 2)
                }
                
            } else {
                self.loadingView
            }
        }
//        .onAppear {
//            self.fetchInsight()
//        }
        .animation(.easeInOut)
        
    }
}


struct YPDInsightSummarySection_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightSummarySection(metric: .energy)
    }
}
