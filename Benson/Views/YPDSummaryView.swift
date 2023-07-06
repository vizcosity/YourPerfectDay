//
//  YPDSummaryView.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDSummaryView: View {
    
    // We will be listening to changes in the observed object, published by the data model, and reflecting changes in our view accordingly.
    @State var checkins: [YPDCheckin] = []
    
    @ObservedObject var chartData: YPDChartData
    
    @EnvironmentObject var model: YPDModel
    
    @State var selectedAggregationCriteria: AggregationCriteria = .day
    
    @State var selectedAttributePickerIndex: Int = 0
    @State var selectedTimeUnitPickerIndex: Int = 0
    
    var selectedTimeUnit: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
    }
    
    // Magic numbers.
    var chartViewHorizontalPadding: CGFloat = 10
    
    var body: some View {
        NavigationView {
            BackgroundViewWrapper {
                ScrollView {
                    
                    YPDMetricSelectionAndChartView(chartData: chartData, chartViewHorizontalPadding: chartViewHorizontalPadding)
                                            
                        YPDInsightSummarySection(insights: self.model.insightsForSelectedAttributes)
                        
                        YPDRecentCheckinsSection(checkins: self.checkins)
                                            
                    // Sets the title for the view itself. This is not obeyed for the tab bar item which is why it is repeated on the parent element below.
                }.navigationBarTitle("Summary")
                
                // Sets the title for the tab bar item.
            }.navigationBarTitle("Summary")
            
            
        }
    }
    
}

struct YPDMetricSelectionAndChartView: View {
    
    @ObservedObject var chartData: YPDChartData
    
    // Magic numbers.
    var chartViewHorizontalPadding: CGFloat = 10
    
    var body: some View {
        
            
            YPDChartMetricSelectionHeader(chartData: chartData)
            
            YPDChartView(chartData: chartData, displayChartLegend: true, height: 410)
                .padding([.leading, .trailing], chartViewHorizontalPadding)
        
    }
}

struct YPDChartMetricSelectionHeader: View {
    
    @EnvironmentObject var model: YPDModel
    
    @ObservedObject var chartData: YPDChartData
    
    var body: some View {
        HStack {
            
            ForEach(self.model.selectedMetricAttributes.indices, id: \.self) { i in
                
                YPDMetricAttributePickerButton(onDismiss: { selectedAttribute in
                    withAnimation {
                        
                        // Ensure that we update the model with the newly selected metric attribute
                        self.model.select(metricAttribute: selectedAttribute, atIndex: i)
                        print("Selected \(selectedAttribute.humanReadable) and now fetching new data")
                        self.chartData.fetchNewData(forAttributes: self.model.selectedMetricAttributes, selectedTimeUnit: self.model.selectedAggregationCriteria)
                    }
                })
                
                
                
                if (i != (self.model.selectedMetricAttributes.count - 1)) {
                    Text(",").fontWeight(.bold).foregroundColor(.gray)
                        .padding(.all, -2)
                }
                
            }
            
            Text("by")
                .foregroundColor(.gray)
            
            YPDAggregationCriteriaPickerButton(onDismiss: { aggregationCriteria in
                withAnimation {
                    self.model.select(aggregationCriteria: aggregationCriteria)
                    self.chartData.fetchNewData(forAttributes: self.model.selectedMetricAttributes, selectedTimeUnit: self.model.selectedAggregationCriteria)
                }
                
            })
            Spacer()
            
            Button {
                self.model.addNewSelectedMetricAttribute()
            } label: {
                Text("+")
            }
            
            Button {
                self.model.removeSelectedMetricAttribute()
            } label: {
                Text("-")
            }
            
            
        }.padding(.init([.leading, .trailing]), Constants.Padding)
        .font(.headline)
    }
}



struct YPDSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSummaryView(checkins: _sampleMetricLogs, chartData: .init(attributes: [.generalFeeling], selectedTimeUnit: .week)).environmentObject(YPDModel())
            .environment(\.colorScheme, .dark)
        //        YPDSummaryView(chartData: .init(attributes: ["generalFeeling"], selectedTimeUnit: .week))
        
    }
}
