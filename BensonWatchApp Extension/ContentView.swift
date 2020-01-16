//
//  ContentView.swift
//  BensonWatchApp Extension
//
//  Created by Aaron Baw on 16/01/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("How are you feeling?")
            .bold()
            .multilineTextAlignment(.leading)
            Picker(selection: .constant(1), label: Text("I'm Feeling")) {
                Text("Great").tag(1)
                Text("Not Bad").tag(2)
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Submit")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
