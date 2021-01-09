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
    
    //    var insight: YPDInsight?
    
    var insights: [YPDInsight]?
    
    
    // When the metric changes, the entire view should invalidate and request a new insight.
    var metric: YPDCheckinType? = .generalFeeling
    
    var aggregationCriteria: AggregationCriteria? = .day
    
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
        VStack(alignment: .center) {
            
            if self.insights != nil && !self.insights!.isEmpty {
                
                HStack {
                    Text("Recent Insight")
                        .font(.headline)
                    
                    Spacer()
                }.padding(.init([.top, .leading, .trailing]), Constants.Padding)
                
                ForEach(self.insights!){
                    YPDInsightSummaryView(insight: $0, anomalyMetricLimit: 2)
                }
                
            } else {
                self.loadingView
            }
        }.animation(.easeInOut)
        
    }
}


struct YPDInsightSummarySection_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            YPDInsightSummarySection(metric: .energy)
            YPDInsightSummarySection(
                insights: [.mockedDietaryProtein],
                metric: .caloricIntake,
                aggregationCriteria: .day
            )
            .preferredColorScheme(.dark)
        }
    }
}
