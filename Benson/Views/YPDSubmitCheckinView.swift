//
//  YPDSubmitCheckinView.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI


struct YPDSubmitCheckinView: View {
    
    @State var results: [Float] = [0]
    
    @State var checkinPrompts: [YPDCheckinPrompt] = []
    
    var body: some View {
        
        
        VStack {
            ScrollView {
                ForEach(self.checkinPrompts) { (checkinPrompt) -> YPDCheckinPromptView in
                    
                    let title = checkinPrompt.readableTitle
                    
                    let responses = checkinPrompt.responses
                    
                    let maxRecordableValue = Float(responses.map { $0.value }.sorted().last!)
                    
                    let stepLabels = responses.map { $0.title }
                    
                    
                    let resultIndex = self.checkinPrompts.firstIndex(where: { $0.id == checkinPrompt.id})!
                    
                    
                    let result = self.$results[resultIndex]
                    
                    
                    return YPDCheckinPromptView(result: result, title: title, maxRecordableValue: maxRecordableValue, stepLabels: stepLabels)
                }
            }
            
            YPDButton(title: "Submit") {
                print("Tapped Submit")
            }
        }.navigationBarTitle("How are you feeling?")
        .onAppear(perform: {
            Fetcher.sharedInstance.fetchMetricPrompts { (checkinPrompts) in
                
                self.checkinPrompts = checkinPrompts
                
                self.results = Array.init(repeating: 0, count: self.checkinPrompts.count)
                
                
                print("Fetched metric prompts in view: \(self.checkinPrompts.count)")
                
            }
        })
    }
}

struct YPDSubmitCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSubmitCheckinView()
    }
}
