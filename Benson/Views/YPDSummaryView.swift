//
//  YPDSummaryView.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDAttributePicker: View {
    
    @Binding var selectedPickerIndex: Int
    @Binding var pickerIsDisplayed: Bool
    var options: [String]
    
    var body: some View {
    
       VStack {
                
        HStack {
            Spacer()
            Button(action: {
                self.pickerIsDisplayed = false
            }) {
                Text("Done")
            }
        }.padding(.all, 20)
        Spacer()
           Image(systemName: "waveform.path.ecg")
            .resizable()
            .frame(maxWidth: 50, maxHeight: 50)
            .foregroundColor(.red)
        Text("Which attributes would you like to chart?")
                .padding(.top, 15)
           Picker(selection: self.$selectedPickerIndex, label: Text("Which attributes would you like to chart?")) {
            ForEach(0..<self.options.count) {
                Text("\(self.options[$0])").tag($0)
               }
            Spacer()
           }.pickerStyle(DefaultPickerStyle())
           .labelsHidden()
        Spacer()
        }
    }
}

struct YPDTimeUnitPicker: View {
    
    @Binding var selectedPickerIndex: Int
    @Binding var pickerIsDisplayed: Bool
    var options: [String]
    
    var body: some View {
            
       VStack {
        HStack {
            Spacer()
            Button(action: {
                self.pickerIsDisplayed = false
            }) {
                Text("Done")
            }
        }.padding(.all, 20)
        Spacer()
           Image(systemName: "timelapse")
            .resizable()
            .frame(maxWidth: 50, maxHeight: 50)
            .foregroundColor(.blue)
            Text("How would you like to aggregate the data?")
                .padding(.top, 15)
           Picker(selection: self.$selectedPickerIndex, label: Text("How would you like to aggregate the data?")) {
              ForEach(0..<self.options.count) {
                Text("\(self.options[$0])").tag($0)
               }
            Spacer()
           }.pickerStyle(DefaultPickerStyle())
           .labelsHidden()
        Spacer()
        }
    }
}

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
        
        VStack {
            
            VStack {
                
                HStack {
                    Text("Your Chart")
                        .font(.largeTitle)
                    Spacer()
                }.padding([.top, .leading, .trailing], Constants.Padding)
            
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
               }.padding(.init([.top, .leading, .trailing]), 10)
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
                 .padding(.init([.top, .leading, .trailing]), 10)
                
                if !self.checkins.isEmpty {
                    YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: self.checkins)
                }
            }.onAppear {
                Fetcher.sharedInstance.fetchMetricLogs(completionHandler: { self.checkins = $0 })
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
