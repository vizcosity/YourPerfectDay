//
//  YPDCheckinsView.swift
//  Benson
//
//  Created by Aaron Baw on 29/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI
import Combine

struct YPDCheckinsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var subscriptions = Set<AnyCancellable>()
    @State var checkins: [YPDCheckin] = []
    
    /// The maximum number of checkins which should be displayed at once.
    var maxDisplayedCheckins: Int
    
    var body: some View {
        
        List {
                ForEach(0..<checkins.prefix(maxDisplayedCheckins).count){ index in
                    
                    YPDRecentCheckinView(displayedCheckin:
                                            self.checkins[index], displayShadow: false)
                        .cardify(innerPadding: 0, outerPadding: 0)
                    
                }
                .onDelete(perform: { indexSet in
                    let checkinsToRemove = checkins.enumerated().filter { indexSet.map { Int($0) }.contains($0.offset) }.map(\.element)
                    self.checkins = checkins.filter { !checkinsToRemove.contains($0) }
                    checkinsToRemove.forEach {
                        Fetcher
                            .sharedInstance
                            .remove(checkin: $0)
                            .sink(receiveCompletion: { _ in}, receiveValue: { _ in })
                            .store(in: &subscriptions)
                    }
                })
            }
        .listStyle(SidebarListStyle())
            .navigationBarTitle("Checkin History")
            
    }
}

struct YPDCheckinsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            YPDCheckinsView(checkins: .init(repeating: _sampleCheckin, count: 200), maxDisplayedCheckins: 10)
            YPDCheckinsView(checkins: .init(repeating: _sampleCheckin, count: 200), maxDisplayedCheckins: 10)
                .preferredColorScheme(.dark)
        }
    }
}
