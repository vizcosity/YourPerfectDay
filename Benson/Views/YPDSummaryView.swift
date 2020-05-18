//
//  YPDSummaryView.swift
//  Benson
//
//  Created by Aaron Baw on 18/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDSummaryView: View {
        
    // We will be listening to changes in the observed object, published by the data model, and reflecting changes in our view accordingly.
    @Binding var checkins: [MetricLog]
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                 HStack {
                    Text("Recent Checkins")
                    .font(.headline)
                    Spacer()
                }
                 .padding(.init([.top, .leading, .trailing]), 10)
                
                if !self.checkins.isEmpty {
                    YPDRecentCheckinView(checkin: self.checkins.first!)
                }
            }
        }
        
        
    }
}

struct YPDRecentCheckinsView: View {
    
    @Binding var checkins: [MetricLog]
    
    var body: some View {
        VStack {
          HStack {
              Text("Recent Checkins")
              .font(.headline)
              Spacer()
          }
          .padding(.all, 10)
          
          List {
              ForEach(self.checkins, id: \.self) { (checkin) -> YPDRecentCheckinView in
                  YPDRecentCheckinView(checkin: checkin)
              }
          }
          
      }
    }
}

struct YPDSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDSummaryView(checkins: .constant(_sampleMetricLogs))
    }
}
