//
//  OCKCartesianChartViewWrapper.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import CareKitUI

// TODO: Investigate why the horizontal axis label markers are not appearing.

/// OCKCartersianChartViewWrapper for SwiftUI.
struct OCKCartesianChartViewWrapper: UIViewRepresentable {
    
//    var dataSeries: [OCKDataSeries]
//    var horizontalAxisChartLabels: [String]
    
    @ObservedObject var chartData: YPDChartData
    
    typealias UIViewType = OCKCartesianChartView
    
    func makeUIView(context: Context) -> OCKCartesianChartView {
                
        let chartView = OCKCartesianChartView(type: .line)
                        
        chartView.graphView.dataSeries = self.chartData.dataSeries
        
        //chartView.graphView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        //chartView.graphView.frame = chartViewContainer.bounds
        
        chartView.headerView.removeFromSuperview()
        
       // Remove unwanted header view from the ChartView's stack view.
        chartView.contentStackView.arrangedSubviews.first?.removeFromSuperview()
        
        chartView.graphView.horizontalAxisMarkers = chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5)
        
//        chartView.graphView.horizontalAxisMarkers = ["SAMPLE"]
        
        chartView.backgroundColor = Colour.secondary
                        
//        chartView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        chartView.headerView.titleLabel.text = "My Sample Chart"
        chartView.headerView.isHidden = true
        
        return chartView
        
    }
    
    // This will be called whenever the properties passed down into the view are changed -
    // in which case we need to update the view accordingly.
    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
//        uiView.graphView.dataSeries = []
        uiView.graphView.dataSeries = self.chartData.dataSeries
//        uiView.graphView.dataSeries = []
        
        print("Axis Chart Markers: \(self.chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5).joined(separator: ","))")
        
        uiView.graphView.horizontalAxisMarkers = self.chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5)

        //print("Data series: \(self.chartData.dataSeries.map { $0.dataPoints })")
        
        uiView.graphView.setNeedsLayout()
        uiView.graphView.setNeedsDisplay()
        uiView.setNeedsLayout()
        uiView.setNeedsDisplay()
        
    }
    
}

struct OCKCartesianChartViewWrapper_Previews: PreviewProvider {
    
    static var chartData = YPDChartData(attributes: ["generalFeeling"], selectedTimeUnit: .week)
    
    static var previews: some View {
        VStack {
            Button(action: {
                self.chartData.fetchNewData(selectedTimeUnit: .month)
            }, label: {
                Text("Fetch new data")
            })
            
            Text("\(chartData.attributes.joined(separator:","))")
            
            Text("\(chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5).joined(separator: ","))")
            OCKCartesianChartViewWrapper(chartData: chartData)
            .frame(width: nil, height: 300)
        }
    }
}
