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

/// OCKCartersianChartViewWrapper for SwiftUI.
struct OCKCartesianChartViewWrapper: UIViewRepresentable {
    
//    var dataSeries: [OCKDataSeries]
//    var horizontalAxisChartLabels: [String]
    
    var chartData: ChartData
    
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
        
        chartView.backgroundColor = Colour.secondary
                        
        //chartView.frame = self.chartViewContainer.bounds
        //chartView.headerView.titleLabel.text = "My Sample Chart"
        chartView.headerView.isHidden = true
        
        return chartView
        
    }
    
    // This will be called whenever the properties passed down into the view are changed -
    // in which case we need to update the view accordingly.
    func updateUIView(_ uiView: OCKCartesianChartView, context: Context) {
        uiView.graphView.dataSeries = self.chartData.dataSeries
        uiView.graphView.horizontalAxisMarkers = self.chartData.horizontalAxisChartMarkers
    }
    
    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
}

struct OCKCartesianChartViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        OCKCartesianChartViewWrapper(chartData: .init(data: JSON(), attributes: [], selectedTimeUnit: .day))
    }
}
//
//struct OCKCartersianChartViewWrapper: UIViewRepresentable {
//
//}
