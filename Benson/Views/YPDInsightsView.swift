//
//  YPDInsightsView.swift
//  Benson
//
//  Created by Aaron Baw on 08/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDInsightsView: View {
    @State var insights: [YPDInsight] = []
    var body: some View {
        List(self.insights) { (insight) -> YPDInsightSummaryView in
            YPDInsightSummaryView(insight: insight)
        }.onAppear {
            Fetcher.sharedInstance.fetchInsights(forAggregationCriteria: .day) { (insights) in
                        print("Fetched insights.")
                        self.insights = insights
            }
        }
        
    }
}

struct YPDInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        YPDInsightsView()
    }
}
