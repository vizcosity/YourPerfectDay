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
    
//    var selectedAggregationCriteria: AggregationCriteria {
//        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
//    }
    
    @State var selectedAggregationCriteria: AggregationCriteria = .day
//    @State var selectedMetric: YPDCheckinType = .generalFeeling
    
    @State var selectedAttributePickerIndex: Int = 0
    @State var selectedTimeUnitPickerIndex: Int = 0
    
    
    // TEMP: Generalise this so that we can support multiple attributes in the future.
    var selectedAttribute: YPDCheckinType {
        YPDCheckinType.allCases[self.selectedAttributePickerIndex]
    }
    
    var selectedTimeUnit: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
    }
    
    @State var selectedAttributes: [YPDCheckinType] = [.generalFeeling]
    
    var body: some View {
        NavigationView {
            BackgroundViewWrapper {
                VStack {
                    VStack {
                        HStack {
                            
                            ForEach(self.selectedAttributes.indices, id: \.self) { i in
                                YPDMetricAttributePickerButton(selectedMetric: self.$selectedAttributes[i])
                                
                                if (i != (self.selectedAttributes.count - 1)) {
                                    Text(",").fontWeight(.bold).foregroundColor(.gray)
                                        .padding(.all, -2)
                                }
                                
                            }
                            
                            Text("by")
                                .foregroundColor(.gray)
                            
                            YPDAggregationCriteriaPickerButton(selectedAggregationCriteria: self.$selectedAggregationCriteria, onDismiss: {
                                self.chartData.fetchNewData(forAttributes: self.selectedAttributes, selectedTimeUnit: self.selectedAggregationCriteria)
                            })
                            Spacer()
                            
                            Button {
                                self.selectedAttributes.append(self.selectedAttributes.last!)
                            } label: {
                                Text("+")
                            }
                            
                            // TODO: Investigate index out of bounds error.
                            Button {
                                self.selectedAttributes = [.generalFeeling]
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
                        
                        YPDInsightSummarySection(metric: self.selectedAttribute, aggregationCriteria: self.selectedAggregationCriteria)
                        
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

/// Displays a single YPD insight, linking to the extended YPDInsightExpandedView.
struct YPDInsightSummarySection: View {
    
    @State var insight: YPDInsight?
    
    var metric: YPDCheckinType = .vitality
    var aggregationCriteria: AggregationCriteria = .day
    
    var body: some View {
        VStack(alignment: .leading) {

            if self.insight != nil {
                Text("Recent Insight")
                    .font(.headline)
                    .padding(.init([.top, .leading, .trailing]), Constants.Padding)
                
                YPDInsightSummaryView(insight: self.insight!, anomalyMetricLimit: 2)
            } else {
                // Display an indeterminate progress bar.
                if #available(iOS 14.0, *) {
                    ProgressView("Loading Insights")
                        .padding(.top, Constants.Padding)
                } else {
                    Text("Loading Insights")
                }
            }
        }
        .onAppear {
            Fetcher.sharedInstance.fetchInsights(forMetric: self.metric,  withAggregationCriteria: self.aggregationCriteria, limit: 1) {
                if let firstInsight = $0.first {
                    withAnimation {
                        self.insight = firstInsight
                    }
                }
            }
        }.animation(.easeInOut)
    }
}

struct YPDRecentCheckinsSection: View {
    
    @State var checkins: [YPDCheckin]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Checkins")
                .font(.headline)
                .padding(.init([.top, .leading, .trailing]), Constants.Padding)
            
            if !self.checkins.isEmpty {
                YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: self.checkins)
            }
        }.onAppear {
            Fetcher.sharedInstance.fetchMetricLogs(completionHandler: { checkins in
                withAnimation {
                    self.checkins = checkins
                }
                
            })
        }.animation(.easeInOut)
    }
}


struct YPDSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSummaryView(checkins: _sampleMetricLogs, chartData: .init(attributes: [.generalFeeling], selectedTimeUnit: .week))
        //        YPDSummaryView(chartData: .init(attributes: ["generalFeeling"], selectedTimeUnit: .week))
        
    }
}

struct YPDMetricAttributePickerButton: View, Identifiable {
    
    var id: String {
        UUID.init().uuidString
    }
    
    @State var pickerDisplayed = false
    
    @Binding var selectedMetric: YPDCheckinType
    
    @State var selectedPickerIndex: Int = 0
    
    var onDismiss: () -> Void = {}
    
    var body: some View {
        Button(action: {
            self.pickerDisplayed = true
        }, label: {
//            Text("\(self.selectedAttributes.map { $0.humanReadable }.joined(separator: ","))")
            Text(self.selectedMetric.humanReadable)
        }).sheet(isPresented: self.$pickerDisplayed, onDismiss: {
            // Update the chart data object.
//            self.chartData.fetchNewData(selectedTimeUnit: self.selectedAggregationCriteria)
            self.selectedMetric = YPDCheckinType.allCases[self.selectedPickerIndex]
            self.onDismiss()
        }){
            YPDAttributePicker(selectedPickerIndex: self.$selectedPickerIndex, pickerIsDisplayed: self.$pickerDisplayed, options: YPDCheckinType.allCases.map { $0.humanReadable })
        }
    }
}

struct YPDAggregationCriteriaPickerButton: View {
    
    @State var pickerDisplayed = false
    
    @Binding var selectedAggregationCriteria: AggregationCriteria
    
    @State var selectedPickerIndex: Int = 0
    
    var onDismiss: () -> Void = {}

    var body: some View {
        Button(action: {
            self.pickerDisplayed = true
        }, label: {
            Text("\(self.selectedAggregationCriteria.humanReadable)")
        }).sheet(isPresented: self.$pickerDisplayed, onDismiss: {
            // Update the chart data object.
//            self.chartData.fetchNewData(selectedTimeUnit: self.selectedAggregationCriteria)
            self.selectedAggregationCriteria = AggregationCriteria.allCases[self.selectedPickerIndex]
            self.onDismiss()
        }){
            YPDTimeUnitPicker(selectedPickerIndex: self.$selectedPickerIndex, pickerIsDisplayed: self.$pickerDisplayed, options: AggregationCriteria.allCases.map { $0.humanReadable })
        }
    }
}
