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
                // Show 'last checkin' vs. 'Checkin date' if we know this is the
                // only checkin being displayed.
                Text("\(!self.allCheckins.isEmpty ? "Last Checkin" : "") \(self.displayedCheckin.timeSince)")
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
        .padding(Constants.Padding)
        .background(Color.white)
        .cornerRadius(Constants.defaultCornerRadius)
        .shadow(color: Constants.shadowColour, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
//            .shadow(color: Color.black.opacity(0.15), radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY - 5)
            .padding([.leading, .trailing], Constants.Padding)
        .contextMenu(menuItems: {
            Button(action: {
                Fetcher.sharedInstance.remove(metricLogId: self.displayedCheckin.id ?? "") {
                    
                }
            }, label: {
                Image(systemName: "trash")
                Text("Delete")
            })
        })
        
        
    }
}

struct YPDDivider: View {
    
    var body: some View {
        Rectangle()
            .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
            .frame(width: nil, height: 1, alignment: .center)
    }
    
}

struct YPDAdditionalCheckins: View {
    
    var checkins: [YPDCheckin]
    
    var body: some View {
        
        VStack {
            
            // Horizontal divider.
            YPDDivider()
            
            NavigationLink(destination: YPDCheckinsView(checkins: self.checkins, maxDisplayedCheckins: 20)) {
                HStack {
                    Spacer()
                    HStack {
                        Text("\(self.checkins.count) Checkins this week")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .scaleEffect(0.7)
                    }.foregroundColor(Color.gray)
                }
                .padding([.leading, .trailing], CGFloat(5))
            }
            
        }
    }
    
}

struct RecentCheckinView_Previews: PreviewProvider {
    static var checkins = [_sampleCheckin]
    static var previews: some View {
        YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: .init(repeating: _sampleCheckin, count: 300)).onAppear {
            Fetcher.sharedInstance.fetchMetricLogs(completionHandler: {
                checkins in self.checkins = checkins
                
            })
        }
    }
}
