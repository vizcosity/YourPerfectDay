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
        
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(self.checkinPrompts) { checkinPrompt -> YPDCheckinPromptView in
                        
                        let title = checkinPrompt.readableTitle
                        
                        let responses = checkinPrompt.responseOptions
                        
                        let maxRecordableValue = Float(responses.map { $0.value }.sorted().last!)
                        
                        let stepLabels = responses.map { $0.label }
                        
                        //  print(self.results)
                                                
                        let result = checkinPrompt.responseValue.$_selectedValue
                        
                        
                        return YPDCheckinPromptView(result: result, title: title, maxRecordableValue: maxRecordableValue, stepLabels: stepLabels)
                    }
                }
                
                YPDButton(title: "Submit") {
                    
                    Fetcher.sharedInstance.submitCheckin(checkinPrompts: self.checkinPrompts) { (result) in
                            print("Submitted checkin with response: \(result)")
                    }
                    
                                        
                }
                
            }.navigationBarTitle("How are you feeling?")
            .onAppear(perform: {
                
                Fetcher.sharedInstance.fetchMetricPrompts { (checkinPrompts) in
                                    
                    print("Fetched checkin prompts.") 
                    
                    // Ensure that we assign the results array first to avoid any index out of bounds errors.
                    self.results = Array.init(repeating: 0, count: checkinPrompts.count)
                    
                    self.checkinPrompts = checkinPrompts
                                    
                }
            })
        }
    }
}

struct YPDSubmitCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSubmitCheckinView()
    }
}
