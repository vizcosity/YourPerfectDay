//
//  YPDTimeUnitPicker.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

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

struct YPDTimeUnitPicker_Previews: PreviewProvider {
    static var previews: some View {
        YPDTimeUnitPicker(selectedPickerIndex: .constant(1), pickerIsDisplayed: .constant(true), options: ["Option One", "Option Two"])
    }
}
