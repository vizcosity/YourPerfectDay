//
//  YPDAttributePicker.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
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

struct YPDAttributePicker_Previews: PreviewProvider {
    static var previews: some View {
//        YPDAttributePicker(selectedPickerIndex: .constant(0), pickerIsDisplayed: .constant(true), options: ["Option One", "Option Two", "Option Three"])
        YPDMetricAttributePickerButton(onDismiss: {
            metric in print("\(metric.humanReadable)")
        })
    }
}


struct YPDMetricAttributePickerButton: View, Identifiable {
    
    var id: String = UUID.init().uuidString
    
    @State var pickerDisplayed = false
    
    var selectedMetric: YPDCheckinType {
        YPDCheckinType.allCases[self.selectedPickerIndex]
    }
    
    @State var selectedPickerIndex: Int = 0
    
    var onDismiss: (_ selectedMetric : YPDCheckinType) -> Void = { _ in }
    
    var body: some View {
        Button(action: {
            self.pickerDisplayed = true
        }, label: {
            //            Text("\(self.selectedAttributes.map { $0.humanReadable }.joined(separator: ","))")
            Text(self.selectedMetric.humanReadable)
        }).sheet(isPresented: self.$pickerDisplayed, onDismiss: {
            print("Selected picker index: \(self.selectedPickerIndex)")
            self.onDismiss(self.selectedMetric)
        }){
            YPDAttributePicker(selectedPickerIndex: self.$selectedPickerIndex, pickerIsDisplayed: self.$pickerDisplayed, options: YPDCheckinType.allCases.map { $0.humanReadable })
        }
    }
}

struct YPDAggregationCriteriaPickerButton: View {
    
    @State var pickerDisplayed = false
    
    @State var selectedPickerIndex: Int = 0
    
    var onDismiss: (AggregationCriteria) -> Void = {_ in }
    
    var selectedAggregationCriteria: AggregationCriteria {
        AggregationCriteria.allCases[self.selectedPickerIndex]
    }
    
    var body: some View {
        Button(action: {
            self.pickerDisplayed = true
        }, label: {
            Text("\(selectedAggregationCriteria.humanReadable)")
        }).sheet(isPresented: self.$pickerDisplayed, onDismiss: {
            let selectedAggregationCriteria = AggregationCriteria.allCases[self.selectedPickerIndex]
            self.onDismiss(selectedAggregationCriteria)
        }){
            YPDTimeUnitPicker(selectedPickerIndex: self.$selectedPickerIndex, pickerIsDisplayed: self.$pickerDisplayed, options: AggregationCriteria.allCases.map { $0.humanReadable })
        }
    }
}
