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
    
    //    @State var results: [Float] = [0]
    
    //    @State var checkinPrompts: [YPDCheckinPrompt] = []
    @ObservedObject var model: YPDModel = .shared 
    
    init (){
        //        UIView.appearance().backgroundColor = .systemGroupedBackground
    }
    
    var body: some View {
        
        BackgroundViewWraper {
            VStack {
                ScrollView {
                    HStack{
                        Text("How are you feeling?").font(Font(UIFont.systemFont(ofSize: 35, weight: .bold)))
                        Spacer()
                    }.padding(Constants.Padding + 5)
                    ForEach(self.model.checkinPrompts) { checkinPrompt -> YPDCheckinPromptView in
                        
                        let title = checkinPrompt.readableTitle
                        
                        let responses = checkinPrompt.responseOptions
                        
                        let maxRecordableValue = Float(responses.map { $0.value }.sorted().last!)
                        
                        let stepLabels = responses.map { $0.label }
                        
                        let sliderIndex = self.model.checkinPrompts.firstIndex(where: { $0 == checkinPrompt })
                        
                        var result = self.$model.sliderValues[0]
                        
                        if let sliderIndex = sliderIndex {
                            result = self.$model.sliderValues[sliderIndex]
                        }
                        
                        
                        return YPDCheckinPromptView(result: result, title: title, maxRecordableValue: maxRecordableValue, stepLabels: stepLabels)
                    }
                }
                
                YPDButton(title: "Submit") {
                    // Ensure that we attach the result from each slider to the YPDCheckinPrompt.
                    for i in 0..<self.model.checkinPrompts.count {
                        // The 'results' array is bound to the Sliders which are zero-indexed. We need to add one to ensure that the values being submitted reflect those reported by the checkin prompt.
                        self.model.checkinPrompts[i].responseValue.value = Double(self.model.sliderValues[i] + 1)
                    }
                    Fetcher.sharedInstance.submitCheckin(checkinPrompts: self.model.checkinPrompts) { (result) in
                        print("Submitted checkin with response: \(result)")
                    }
                }.padding(.bottom, Constants.Padding)
            }.navigationBarTitle("Checkin")
        }
    }
}

struct YPDSubmitCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSubmitCheckinView()
    }
}
