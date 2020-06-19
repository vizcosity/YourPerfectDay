//
//  YPDSubmitCheckinView.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

// CHECKPOINT: Bugs in displaying the checkin data values and being able to control sliders.
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
                                                                    
                        let sliderIndex = self.checkinPrompts.firstIndex(where: { $0 == checkinPrompt })
                                                
                        var result = self.$results[0]
                        
                        if let sliderIndex = sliderIndex {
                            result = self.$results[sliderIndex]
                        }
                        
                        
                        return YPDCheckinPromptView(result: result, title: title, maxRecordableValue: maxRecordableValue, stepLabels: stepLabels)
                    }
                }
                
                YPDButton(title: "Submit") {
                    
                    // Ensure that we attach the result from each slider to the YPDCheckinPrompt.
                    for i in 0..<self.checkinPrompts.count {
                        
                        // The 'results' array is bound to the Sliders which are zero-indexed. We need to add one to ensure that the values being submitted reflect those reported by the checkin prompt.
                        self.checkinPrompts[i].responseValue.value = Double(self.results[i] + 1)
                    }
                    
                    Fetcher.sharedInstance.submitCheckin(checkinPrompts: self.checkinPrompts) { (result) in
                            print("Submitted checkin with response: \(result)")
                    }
                    
                                        
                }.padding(.bottom, Constants.Padding)
                
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
