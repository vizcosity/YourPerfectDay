//
//  RecentCheckinView.swift
//  Benson
//
//  Created by Aaron Baw on 10/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDRecentCheckinView: View {
    
    var checkin: MetricLog
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                
                Text("Last Checkin \(self.checkin.timeSince)")
                    .fontWeight(.medium)
                    
                Image(systemName: "clock")
                
            }.foregroundColor(Color.gray)
            
            VStack {
                
                ForEach(0..<self.checkin.metrics.count){ i in
                    HStack {
                        Text("\(self.checkin.metrics[i].type.humanReadable)  \(Int(self.checkin.metrics[i].value))/\(Int(self.checkin.metrics[i].maxValue))")
                                .fontWeight(.medium)
                                
                            Spacer()
                        }
                    
                        YPDProgressBar(progressValue: self.checkin.metrics[i].value/self.checkin.metrics[i].maxValue, colour: Color.blue)
                }
                
            }
            
            // Card below-fold content. (Click for more checkins indicator)
             VStack {
                 Rectangle()
                     .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
                     .frame(width: nil, height: 1, alignment: .center)
                 HStack {
                     Spacer()
                     HStack {
                             Text("12 Checkins this week")
                                 .font(.caption)
                             Image(systemName: "chevron.right")
                                 .scaleEffect(0.7)
                     }.foregroundColor(Color.gray)
                 }
                 .padding(.all, CGFloat(5))
//                 .padding(.bottom, CGFloat(5))
             }
        }
        .padding(15.0).cornerRadius(_DEFAULT_CORNER_RADIUS)
        
        
    }
}

struct RecentCheckinView_Previews: PreviewProvider {
    static var previews: some View {
        YPDRecentCheckinView(checkin: MetricLog(metrics: [MetricAttribute(name: "Mood", value: 2)], timeSince: "2 Hours Ago"))
    }
}
