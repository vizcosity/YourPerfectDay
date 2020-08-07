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
    
    var body: some View {
        YPDCardView(aboveFold: {
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
        }, belowFold: {
            #if MAIN_APP
            if !self.allCheckins.isEmpty   {
                YPDAdditionalCheckins(checkins: self.allCheckins)
            }
            #endif
        }, displayShadow: self.displayShadow)
    }
    
}

struct YPDRecentCheckinViewLegacy: View {
    
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
            #if MAIN_APP
            if !self.allCheckins.isEmpty   {
                YPDAdditionalCheckins(checkins: self.allCheckins)
            }
            #endif
        }
        .padding(.all, Constants.Padding)
        .background(Color.white)
        .cornerRadius(Constants.defaultCornerRadius)
        .shadow(color: Constants.shadowColour, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
//            .shadow(color: Color.black.opacity(0.15), radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY - 5)
            .padding([.leading, .trailing], Constants.Padding)
        .contextMenu(menuItems: {
            Button(action: {
                #if MAIN_APP
                Fetcher.sharedInstance.remove(metricLogId: self.displayedCheckin.id ?? "") {
                    
                }
                #endif
                
            }, label: {
                Image(systemName: "trash")
                Text("Delete")
            })
        })
        
        
    }
}

#if MAIN_APP
struct YPDAdditionalCheckins: View {
    
    var checkins: [YPDCheckin]
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: YPDCheckinsView(checkins: self.checkins, maxDisplayedCheckins: 20)) {
                HStack {
                    Spacer()
                    HStack {
                        Text("\(self.checkins.count) more checkins")
                            .font(.caption)
                        Image(systemName: "chevron.right")
                            .scaleEffect(0.7)
                    }.foregroundColor(Color.gray)
                }
                .padding([.leading, .trailing, .top], CGFloat(5))
                .padding(.bottom, -5)
            }
            
        }
    }
    
}
#endif

#if MAIN_APP
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
#endif
