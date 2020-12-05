//
//  YPDCheckinPrompt.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDCheckinPromptView: View {
    
    @Binding var result: Float
    
    var title: String
    
    var maxRecordableValue: Float
    
    var stepLabels: [String]
    
    var minimumValueText: String {
        return self.stepLabels.first!
    }
    
    var maximumValueText: String {
        return self.stepLabels.last!
    }
    
    var selectedIndex: Int {
        return Int(self.result)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                    .fontWeight(.semibold)
                Spacer()
            }.padding([.trailing, .top], Constants.Padding)
            Divider()
            Text(self.stepLabels[self.selectedIndex])
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            Slider(value: self.$result, in: Float(0)...Float(self.maxRecordableValue - 1), step: 1.0, minimumValueLabel: Text(self.minimumValueText).fontWeight(.semibold), maximumValueLabel: Text(self.maximumValueText).fontWeight(.semibold), label: {
                Text(self.title)
            })
        }
        .padding(Constants.cardPadding)
        .background(Color.white)
        .cornerRadius(Constants.defaultCornerRadius)
        .shadow(color: Constants.shadowColour, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
            
        .padding(Constants.cardPadding)
    }
}

extension YPDCheckinPromptView {
    init(checkinPrompt: YPDCheckinPrompt, sliderValue: Binding<Float>){
        self.title = checkinPrompt.readableTitle
        self.maxRecordableValue = Float(checkinPrompt.responseOptions.map { $0.value }.sorted().last!)
        self.stepLabels = checkinPrompt.responseOptions.map { $0.label }
        self._result = sliderValue
    }
}

struct YPDCheckinPromptView_Previews: PreviewProvider {
    @State var result = 0
    @State var maxRecordableValue = 4
    static var previews: some View {
        ScrollView {
            YPDCheckinPromptView(result: .constant(2), title: "I'm Feeling", maxRecordableValue: Float(4), stepLabels: ["Horrible", "Meh", "Okay", "Not Bad", "Great"])
                .previewLayout(.sizeThatFits)
            
        }
        
    }
}
