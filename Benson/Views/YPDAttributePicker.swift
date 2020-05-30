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
        YPDAttributePicker(selectedPickerIndex: .constant(0), pickerIsDisplayed: .constant(true), options: ["Option One", "Option Two", "Option Three"])
    }
}
