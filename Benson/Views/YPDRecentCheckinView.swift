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
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                
                Text("Last Checkin \(self.displayedCheckin.timeSince)")
                    .font(.footnote)
                    .fontWeight(.regular)
                Image(systemName: "clock")
                    .resizable()
                .frame(width: 12, height: 12)
                
            }.foregroundColor(Color.gray)
            
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
            
            // Card below-fold content. (Click for more checkins indicator)
            if !self.allCheckins.isEmpty   {
                YPDAdditionalCheckins(checkins: self.allCheckins)
            }
        }
        .padding(15.0).cornerRadius(Constants.defaultCornerRadius)
        .background(Color.white)
        .cornerRadius(6.0)
        .shadow(color: Color.init(red: 0.9, green: 0.9, blue: 0.9), radius: 10, x: 0, y: 10)
        .padding(.all, 10)
        
        
    }
}

struct RecentCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDRecentCheckinView(displayedCheckin: YPDCheckin(attributeValues: [YPDCheckinAttributeValue(type:"mood", name: "Mood", value: 3)], timeSince: "2 Hours Ago"))
    }
}

struct YPDAdditionalCheckins: View {
    
    var checkins: [YPDCheckin]
    
    var body: some View {
        VStack {
            
            // Horizontal divider.
            Rectangle()
                .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
                .frame(width: nil, height: 1, alignment: .center)
            
            // TODO: Create a new view which will display all the checkins.
            NavigationLink(destination: YPDCheckinsView(checkins: self.checkins)) {
                HStack {
                    Spacer()
                    HStack {
                        Text("\(self.checkins.count) Checkins this week")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .scaleEffect(0.7)
                    }.foregroundColor(Color.gray)
                }
                .padding(.all, CGFloat(5))
            }

        }
    }
    
}
