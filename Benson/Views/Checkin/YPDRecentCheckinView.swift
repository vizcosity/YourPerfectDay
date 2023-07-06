//
//  RecentCheckinView.swift
//  Benson
//
//  Created by Aaron Baw on 10/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDRecentCheckinView: View {
    
    var displayedCheckin: YPDCheckin
    var allCheckins: [YPDCheckin] = []
    var displayShadow: Bool = true
    
    var timeSinceText: String {
        "\(!self.allCheckins.isEmpty ? "Last Checkin" : "") \(self.displayedCheckin.timeSince)"
    }
    
    var content: some View {
        YPDCardView(aboveFold: {
        }, mainContent: {
            VStack {
                
                ForEach(0..<self.displayedCheckin.attributeValues.count){ i in
                    HStack {
                        Text("\(self.displayedCheckin.attributeValues[i].type.humanReadable)  \(Int(self.displayedCheckin.attributeValues[i].value))/\(Int(self.displayedCheckin.attributeValues[i].maxValue))")
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    
                    YPDProgressBar(progressValue: CGFloat(self.displayedCheckin.attributeValues[i].value/self.displayedCheckin.attributeValues[i].maxValue), colour: Color.blue)
                }
                
            }
            .padding(.bottom, 5)
        }, belowFold: {
            HStack {
                Label(timeSinceText, systemImage: "clock")
                    .foregroundColor(Color.gray)
                Spacer()
                if !self.allCheckins.isEmpty   {
                    Text("\(self.allCheckins.count) more checkins \(Image(systemName: "chevron.right"))")
                }
                
            }.font(.caption)
            .padding(.top, 5)
        }, displayShadow: self.displayShadow)
    }
    
    var body: some View {
        if self.allCheckins.isEmpty {
            content
        } else {
        NavigationLink(
            destination: YPDCheckinsView(checkins: self.allCheckins, maxDisplayedCheckins: Constants.AllCheckinsView.maxDisplayedCheckins),
            label: { content })
        }
    }
    
}

struct YPDAdditionalCheckins: View {
    
    var checkins: [YPDCheckin]
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: YPDCheckinsView(checkins: self.checkins, maxDisplayedCheckins: 20)) {
                Text("\(self.checkins.count) more checkins \(Image(systemName: "chevron.right"))")
                //                    .padding([.leading, .trailing, .top], CGFloat(5))
                //                    .padding(.bottom, -5)
            }
            
        }
    }
    
}

#if MAIN_APP
struct RecentCheckinView_Previews: PreviewProvider {
    static var checkins = [_sampleCheckin]
    static var previews: some View {
        Group {
            YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: .init(repeating: _sampleCheckin, count: 300))
            YPDRecentCheckinView(displayedCheckin: self.checkins.first!)
                
        }.previewLayout(.sizeThatFits)
    }
}
#endif
