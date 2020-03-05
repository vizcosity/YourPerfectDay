//
//  ContentView.swift
//  BensonWatchApp Extension
//
//  Created by Aaron Baw on 16/01/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var responseValue: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("How are you feeling?")
            .bold()
            .multilineTextAlignment(.leading)
            Picker(selection: .constant(1), label: Text("I'm Feeling")) {
                Text("Great").tag(1)
                Text("Not Bad").tag(2)
            }
            Slider(value: self.$responseValue, in: 0...5)
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Submit")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State var responseValue: Double = 0.0
    
    static var previews: some View {
        ContentView(responseValue: self.$responseValue)
    }
}
