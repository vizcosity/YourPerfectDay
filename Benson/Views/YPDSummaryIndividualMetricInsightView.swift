//
//  YPDSummaryIndividualMetricInsightView.swift
//  The SummaryIndividualMetricInsightView caters for the individual metrics which are displayed beneath the metric of interest progress bar within the YPDSummaryInsightView.
//
//  Created by Aaron Baw on 29/03/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDSummaryIndividualMetricInsightView: View {
    
    var metricName: String
    var percentageChangeValue: Double
    
    var timePeriod: String
//    var timePeriodCapitalised: String {
//        get {
//            // Capitalise the first letter.
//            self.timePeriod.prefix(1).uppercased() + self.timePeriod.dropFirst()
//        }
//        set {
//            self.timePeriod = newValue
//        }
//    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Image(systemName: self.percentageChangeValue >= 0 ? "chevron.up" : "chevron.down").foregroundColor(self.percentageChangeValue >= 0 ? Color.green : Color.red)
                    
                    Text("\(self.percentageChangeValue >= 0 ? "Increase" : "Decrease") in \(self.metricName)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                }
                
                Text("Over the last \(self.timePeriod) your \(self.metricName) \(self.percentageChangeValue >= 0 ? "increased" : "fell") by \(self.percentageChangeValue.formattedAsPercentage).")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

struct YPDSummaryIndividualMetricInsightView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSummaryIndividualMetricInsightView(metricName: "dietaryCarbohydrates", percentageChangeValue: 0.34, timePeriod: "week")
        
    }
}
