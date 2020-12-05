//
//  YPDSubmitCheckinView.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

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
