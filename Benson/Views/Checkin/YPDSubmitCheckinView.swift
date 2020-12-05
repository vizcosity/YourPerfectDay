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
    
    @EnvironmentObject var model: YPDModel
    
    var body: some View {
        BackgroundViewWrapper {
            ZStack(alignment: .center) {
                GeometryReader { geometry in
                    ScrollView {
                        HStack{
                            Text("How are you feeling?").font(Font(UIFont.systemFont(ofSize: 35, weight: .bold)))
                            Spacer()
                        }.padding(Constants.Padding + 5)
                        ForEach(0..<model.checkinPrompts.count) { (idx: Int) in
                            YPDCheckinPromptView(
                                checkinPrompt: model.checkinPrompts[idx],
                                sliderValue: Binding<Float>.init(
                                    get: { Float(model.checkinPrompts[idx].responseValue.value) },
                                    set: { model.checkinPrompts[idx].responseValue.value = Double($0) }
                                )
                            )
                        }
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height:50)
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
                    }.background(Color.clear)
                    .padding(.bottom, Constants.Padding)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 25)
                    .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
                }.navigationBarTitle("Checkin")
            }
        }
    }
}

struct YPDSubmitCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSubmitCheckinView()
            .environmentObject(YPDModel())
    }
}
