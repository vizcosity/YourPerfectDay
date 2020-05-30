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
    
    // TODO: Refactor this to become an EnvironmentObject.
    // TODO: Refactor selected attributes to make use of an enum.
    var selectedAttributes: [String] {
        [self.selectedAttribute.rawValue]
    }
    
    var selectedAggregationCriteria: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
    }
    
    @State var selectedAttributePickerIndex: Int = 0
    @State var selectedTimeUnitPickerIndex: Int = 0

    
    // TEMP: Generalise this so that we can support multiple attributes in the future.
    var selectedAttribute: YPDCheckinType {
        YPDCheckinType.allCases[self.selectedAttributePickerIndex]
    }
    
    var selectedTimeUnit: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedTimeUnitPickerIndex]
    }
    
    @State var attributePickerIsDisplayed: Bool = false
    @State var timeunitPickerIsDisplayed: Bool = false
    
    var body: some View {
        
        
        NavigationView {
            
            
        
            ZStack {
                
                Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    VStack {
                        
    //                    HStack {
    //                        Text("Your Chart")
    //                            .font(.headline)
    //                        Spacer()
    //                    }.padding([.top, .leading, .trailing], Constants.Padding)
    //
                        HStack {
                            
                            Button(action: {
                                self.attributePickerIsDisplayed = true
                            }, label: {
                                Text("\(self.selectedAttributes.joined(separator: ","))")
                            }).sheet(isPresented: self.$attributePickerIsDisplayed, onDismiss: {
                                 // Update the chart data object.
                                 self.chartData.fetchNewData(forAttributes: self.selectedAttributes)
                            }) {
                                YPDAttributePicker(selectedPickerIndex: self.$selectedAttributePickerIndex, pickerIsDisplayed: self.$attributePickerIsDisplayed, options: YPDCheckinType.allCases.map { $0.rawValue })
                            }

                            
                            Text("by")
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                self.timeunitPickerIsDisplayed = true
                            }, label: {
                                Text("\(self.selectedAggregationCriteria.rawValue)")
                            }).sheet(isPresented: self.$timeunitPickerIsDisplayed, onDismiss: {
                                // Update the chart data object.
                                self.chartData.fetchNewData(selectedTimeUnit: self.selectedAggregationCriteria)
                            }){
                                    YPDTimeUnitPicker(selectedPickerIndex: self.$selectedTimeUnitPickerIndex, pickerIsDisplayed: self.$timeunitPickerIsDisplayed, options: AggregationCriteria.allCases.map { $0.rawValue })
                            }.onDisappear {
                                // Update the chart data object.
                                self.chartData.fetchNewData(selectedTimeUnit: self.selectedTimeUnit)
                            }
                           Spacer()
                        }.padding(.init([.top, .leading, .trailing]), Constants.Padding)
                        .font(.headline)
                        
                        OCKCartesianChartViewWrapper(chartData: self.chartData)
                            .frame(maxHeight: 300)
                            .padding(.all, 10)
                    }
                    
                    VStack {
                        
                         HStack {
                            Text("Recent Checkins")
                            .font(.headline)
                            Spacer()
                        }
                         .padding(.init([.top, .leading, .trailing]), Constants.Padding)
                        
                        if !self.checkins.isEmpty {
                            YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: self.checkins)
                        }
                    }.onAppear {
                        Fetcher.sharedInstance.fetchMetricLogs(completionHandler: { self.checkins = $0 })
                    }
                }.navigationBarTitle("Summary")
            }
            
        }
        
        
    }
}

struct YPDRecentCheckinsView: View {
    
    @Binding var checkins: [YPDCheckin]
    
    var body: some View {
        VStack {
          HStack {
              Text("Recent Checkins")
              .font(.headline)
              Spacer()
          }
          .padding(.all, 10)
          
          List {
              ForEach(self.checkins, id: \.self) { (checkin) -> YPDRecentCheckinView in
                  YPDRecentCheckinView(displayedCheckin: checkin)
              }
          }
          
      }
    }
}

struct YPDSummaryView_Previews: PreviewProvider {
    static var previews: some View {
//        YPDSummaryView(checkins: .constant(_sampleMetricLogs), chartData: .init(attributes: ["generalFeeling"], selectedTimeUnit: .week))
        YPDSummaryView(chartData: .init(attributes: ["generalFeeling"], selectedTimeUnit: .week))

    }
}
