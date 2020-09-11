//
//  YPDChartView.swift
//  A common chart view used to display metric data; built with SwiftUICharts.
//  YourPerfectDay
//
//  Created by Aaron Baw on 30/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct YPDChartView: View {
    
    @ObservedObject var chartData: YPDChartData
    
    var chartTitle: String = ""
    
    var chartLegend: String {
        displayChartLegend ?  chartData.attributes.map { $0.humanReadable }.joined(separator: ", ") : ""
    }
    
    var displayChartLegend: Bool = true
    
    private var plottableData: [[Double]] {
        (chartData.data ?? [[]]).map { $0.map { $0.1 } }
    }
    
    var height: CGFloat = 400
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                RoundedRectangle(cornerRadius: Constants.defaultCornerRadius).fill(Color.white)
                    .shadow(color: Constants.shadowColour, radius: Constants.shadowRadius, x: Constants.shadowX , y: Constants.shadowY)
                    .frame(height: height)
                
                
                // TEMP: For now we wish to use the first element of the plottableData array.
                VStack {
                    ForEach(plottableData, id: \.self, content: { data in
//
                        LineView(data: data, title: chartTitle, legend: chartLegend, style: Styles.barChartStyleNeonBlueLight, valueSpecifier: "%.2f")
                            .padding([.leading, .trailing, .bottom], Constants.cardPadding)
                            .frame(height: height)
                    })
                                        
//                    MultiLineChartView(data: plottableData.map { ($0, GradientColor(start: .blue, end: .pink)) }, title: "Sample Multiple Lines")
                    
//                    LineChartView(data: plottableData[0], title: "General Feeling")
                                        
                    HStack {
                        ForEach(chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5), id: \.self, content: { dateString in
                            Spacer()
                            Text("\(dateString)")                    .font(.system(size: 13))
                                .fontWeight(.none)
                            Spacer()
                            
                        })
                    }
                    .foregroundColor(.gray).padding(.top, -38)
                    
//                    Text(chartData.horizontalAxisChartMarkers.sample(withAroundNumberOfPoints: 5).joined())
//                    Text(chartData.data?.debugDescription ?? "Loading")
                    
                }
                
                
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
        }.padding(10)
        .frame(height:height)
        //        .shadow(color: Constants.shadowColour, radius: 10, x: 0, y: 0)
    }
}

struct YPDChartView_Previews: PreviewProvider {
    
    static var seriesOne: [(Date,Double)] = [(Date(),22), (Date(timeIntervalSinceNow: 100003), 23), (Date(timeIntervalSinceNow: 400003), 35)]
    
    static var seriesTwo: [(Date, Double)] = [(Date(),34), (Date(timeIntervalSinceNow: 100003), 45), (Date(timeIntervalSinceNow: 400003), 22)]
    
    static var previews: some View {
//        YPDChartView(chartData: YPDChartData(multipleSeries: [[(Date(timeIntervalSinceNow: -109000), 1), (Date(timeIntervalSinceNow: -300000), 1), (Date(), 1), (Date(), 4), (Date(), 3)]], attributes: [.generalFeeling]))
//            .previewLayout(.sizeThatFits)
        YPDChartView(chartData: YPDChartData(multipleSeries: [seriesOne, seriesTwo] ,attributes: [.generalFeeling, .generalFeeling], selectedTimeUnit: .day))
            .previewLayout(.sizeThatFits)
    }
}
