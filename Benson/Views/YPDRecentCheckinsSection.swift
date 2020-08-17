//
//  YPDRecentCheckinsSection.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 15/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDRecentCheckinsSection: View {
    
    @State var checkins: [YPDCheckin]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Checkins")
                .font(.headline)
                .padding(.init([.top, .leading, .trailing]), Constants.Padding)
            
            if !self.checkins.isEmpty {
                YPDRecentCheckinView(displayedCheckin: self.checkins.first!, allCheckins: self.checkins)
            }
        }.onAppear {
            Fetcher.sharedInstance.fetchMetricLogs(completionHandler: { checkins in
                withAnimation {
                    self.checkins = checkins
                }
                
            })
        }.animation(.easeInOut)
    }
}

struct YPDRecentCheckinsSection_Previews: PreviewProvider {
    static var previews: some View {
        YPDRecentCheckinsSection(checkins: [])
    }
}
