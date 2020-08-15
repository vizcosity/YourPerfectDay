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
    
    
    // TEMP: Generalise this so that we can support multiple attributes in the future.
//    var selectedAttribute: YPDCheckinType {
//        YPDCheckinType.allCases[self.selectedAttributePickerIndex]
//    }
    
    var selectedTimeUnit: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
    }
    
    // Why is it that when we modify a child of this array, the subscribed views do not change?
    @State var selectedAttributes: [YPDCheckinType] = [.generalFeeling]
    
    var body: some View {
        NavigationView {
            BackgroundViewWrapper {
                VStack {
                    VStack {
                        
                        HStack {
                            
                            ForEach(self.model.selectedMetricAttributes.indices, id: \.self) { i in
                                
//                                YPDMetricAttributePickerButton(selectedMetric: self.$selectedAttributes[i], onDismiss: {
//                                    withAnimation {
//                                        self.chartData.fetchNewData(forAttributes: self.selectedAttributes, selectedTimeUnit: self.selectedAggregationCriteria)
//                                    }
//                                })
//
                                YPDMetricAttributePickerButton(onDismiss: { selectedAttribute in
                                    withAnimation {
                                        // Ensure that we update the model with the newly selected metric attribute
                                        self.model.select(metricAttribute: selectedAttribute, atIndex: i)
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
                                    self.chartData.fetchNewData(forAttributes: self.model.selectedMetricAttributes, selectedTimeUnit: self.model.selectedAggregationCriteria)
                                    self.model.select(aggregationCriteria: aggregationCriteria)
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
                        
                        OCKCartesianChartViewWrapper(chartData: self.chartData)
                            .frame(maxHeight: 300)
                            .padding([.leading, .trailing], Constants.Padding)
                    }
                    
                    ScrollView {
                        
                        YPDInsightSummarySection(insights: self.model.insightsForSelectedAttributes)
                        
                        YPDRecentCheckinsSection(checkins: self.checkins)
                        
                        Spacer()
                    }
                    
                    // Sets the title for the view itself. This is not obeyed for the tab bar item which is why it is repeated on the parent element below.s
                }.navigationBarTitle("Summary")
                
                // Sets the title for the tab bar item.
            }.navigationBarTitle("Summary")
            
            
        }
    }
    
}


struct YPDSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSummaryView(checkins: _sampleMetricLogs, chartData: .init(attributes: [.generalFeeling], selectedTimeUnit: .week)).environmentObject(YPDModel())
        //        YPDSummaryView(chartData: .init(attributes: ["generalFeeling"], selectedTimeUnit: .week))
        
    }
}

