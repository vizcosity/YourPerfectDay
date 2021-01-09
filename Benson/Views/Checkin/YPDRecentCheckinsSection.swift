//
//  YPDRecentCheckinsSection.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 15/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import Combine

struct YPDRecentCheckinsSection: View {
    
    @State var subscriptions = Set<AnyCancellable>()
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
//            Fetcher.sharedInstance.fetchMetricLogs(completionHandler: { checkins in
//                withAnimation {
//                    self.checkins = checkins
//                }
//
//            })
//            print("Fetching metric logs")
            Fetcher
                .sharedInstance
                .fetchMetricLogs()
                .sink(
                    receiveCompletion: { error in print(error) },
                      receiveValue: { (checkins: [YPDCheckin]) in
                    withAnimation {
                        print("Fetched Checkins")
                        self.checkins = checkins
                    }
                })
                .store(in: &subscriptions)
        }.animation(.easeInOut)
    }
}

struct YPDRecentCheckinsSection_Previews: PreviewProvider {
    static var previews: some View {
        YPDRecentCheckinsSection(checkins: [])
    }
}
