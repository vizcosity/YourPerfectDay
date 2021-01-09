//
//  YPDInsightsView.swift
//  Benson
//
//  Created by Aaron Baw on 08/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import Combine

struct YPDInsightsView: View {
    @State var insights: [YPDInsight]
    @State var subscriptions = Set<AnyCancellable>()
    var body: some View {
        List(self.insights) { (insight) -> YPDInsightSummaryView in
            YPDInsightSummaryView(insight: insight, anomalyMetricLimit: 2)
        }.onAppear {
            // Checkpoint: Investigating index out of bounds error for retrieving insights.
            UITableView.appearance().separatorStyle = .none
//            Fetcher.sharedInstance.fetchInsights(withAggregationCriteria: .day, limit: 30) { (insights) in
//                print("Fetched insights.")
//                self.insights = insights
//            }
            Fetcher
                .sharedInstance
                .fetchInsights(withAggregationCriteria: .day, limit: 30)
                .catch { _ in Just([]) }
                .assign(to: \.insights, on: self)
                .store(in: &subscriptions)
                
        }.onDisappear {
            UITableView.appearance().separatorStyle = .singleLine
            
        }
        
    }
}

struct YPDInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightsView(insights: _sampleInsights)
    }
}
