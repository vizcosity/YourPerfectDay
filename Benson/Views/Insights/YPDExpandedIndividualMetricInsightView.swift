//
//  YPDExpandedIndividualMetricInsightView.swift
//  Benson
//
//  Created by Aaron Baw on 21/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDExpandedIndividualMetricInsightView: View {
     
        var metricName: String
        var percentageChangeValue: Double
        
        var timePeriod: String
    
        var anomalyMetric: YPDAnomalyMetric

        var body: some View {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image(systemName: self.percentageChangeValue >= 0 ? "chevron.up" : "chevron.down").foregroundColor(self.percentageChangeValue >= 0 ? Color.green : Color.red)
                            .scaleEffect(0.8)
                        
                        Text("\(self.percentageChangeValue >= 0 ? "Increase" : "Decrease") in \(self.metricName)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(0.0)
                    
                    Text("Your \(self.metricName) \(self.percentageChangeValue >= 0 ? "increased" : "fell") by \(self.percentageChangeValue.formattedAsPercentage).")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .padding(.top, -5.0)
                }.padding(.all, 0)
            .lineSpacing(0)
    //            Spacer()

        }
}

struct YPDExpandedIndividualMetricInsightView_Previews: PreviewProvider {
    static var previews: some View {
        YPDExpandedIndividualMetricInsightView(metricName: "Vitality", percentageChangeValue: 0.32, timePeriod: "last week", anomalyMetric: YPDAnomalyMetric(metricAttribute: .energy, affectingMetricAttribute: .basalEnergyBurned, localChange: 0.34, localMean: 0.53, globalChange: 0.1, globalMean: 3, correlation: 0.34, importance: 1, timePeriod: "3 days", precedingData: [(Date(), 2.1), (Date(), 1.2)]))
    }
}
