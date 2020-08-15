//
//  OCKCartesianChartViewWrapper.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftyJSON
import CareKitUI

// TODO: Investigate why the horizontal axis label markers are not appearing.
// Checkpoint: Investigating the square icon subview to see why it becomes enlarged in some cases.

/// OCKCartersianChartViewWrapper for SwiftUI.
struct OCKCartesianChartViewWrapper: UIViewRepresentable {
    
//    var dataSeries: [OCKDataSeries]
//    var horizontalAxisChartLabels: [String]
    
    @ObservedObject var chartData: YPDChartData
    
    typealias UIViewType = OCKCartesianChartView
    
    func makeUIView(context: Context) -> OCKCartesianChartView {
                
        let chartView = OCKCartesianChartView(type: .line)
                        
        chartView.graphView.dataSeries = self.chartData.dataSeries
        
//        chartView.graphView.subviews
        
        //chartView.graphView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        //chartView.graphView.frame = chartViewContainer.bounds
        
        chartView.headerView.removeFromSuperview()
        
//        chartView.graphView.yMaximum = 3
        
       // Remove unwanted header view from the ChartView's stack view.
        chartView.contentStackView.arrangedSubviews.first?.removeFromSuperview()
        
        chartView.graphView.horizontalAxisMarkers = chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5)
        
//        chartView.graphView.horizontalAxisMarkers = ["SAMPLE"]
        
        chartView.backgroundColor = Colour.secondary
                        
//        chartView.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
//        chartView.headerView.titleLabel.text = "My Sample Chart"
        chartView.headerView.isHidden = true
        
//        chartView.translatesAutoresizingMaskIntoConstraints = false
        
//        chartView.contentStackView.clear()
        let graphLegendView = chartView.graphView.subviews[3]
        graphLegendView.translatesAutoresizingMaskIntoConstraints = false
                
        // chartView.graphView.legend
        
//        graphLegendView.frame = CGRect(x: graphLegendView.frame.minX, y: graphLegendView.frame.minY, width: graphLegendView.frame.width, height: )
        
        
        
        
        
//        chartView.bounds = CGRect(x:0, y:0, width: 500, height: 500)
                
        return chartView
        
    }
    
    // This will be called whenever the properties passed down into the view are changed -
    // in which case we need to update the view accordingly.
    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        
        uiView.graphView.dataSeries = self.chartData.dataSeries
        
        let (minY, maxY) = self.chartData.minMaxYValues
        
        uiView.graphView.yMaximum = maxY
        uiView.graphView.yMinimum = minY
        
        uiView.graphView.horizontalAxisMarkers = self.chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5)

        
        uiView.graphView.setNeedsLayout()
        uiView.graphView.setNeedsDisplay()
        uiView.setNeedsLayout()
        uiView.setNeedsDisplay()
        
    }
    
}

struct OCKCartesianChartViewWrapper_Previews: PreviewProvider {
    
    static var chartData = YPDChartData(attributes: [.generalFeeling], selectedTimeUnit: .week)
    
    static var anomalyMetricChartData = YPDChartData(data: _sampleInsights[0].mostImportantAnomalyMetrics[0].precedingData, attributes: [.vitality], selectedTimeUnit: .day)
    
    static var previews: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.chartData.fetchNewData(selectedTimeUnit: .month)
            }, label: {
                Text("Fetch new data")
            })
            
            Text("\(chartData.attributes.map { $0.humanReadable }.joined(separator:","))")
            
            Text("\(chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5).joined(separator: ","))")
            OCKCartesianChartViewWrapper(chartData: anomalyMetricChartData)
            .frame(width: nil, height: 300)
            
            Text("Chart Data:")
            Text("\(_sampleInsights[0].mostImportantAnomalyMetrics[0].precedingData.description)")
        }
    }
}
