//
//  YPDCheckinsView.swift
//  Benson
//
//  Created by Aaron Baw on 29/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDCheckinsView: View {
    
    var checkins: [YPDCheckin]
    
    /// The maximum number of checkins which should be displayed at once.
    var maxDisplayedCheckins: Int
    
    init(checkins: [YPDCheckin], maxDisplayedCheckins: Int? = nil){
        self.checkins = checkins
        self.maxDisplayedCheckins = maxDisplayedCheckins ?? checkins.count
    }
    
    var body: some View {
        //            ScrollView {
        //                List(0..<min(self.maxDisplayedCheckins, self.checkins.count)) { (i) -> YPDRecentCheckinView in
        //                    YPDRecentCheckinView(displayedCheckin: self.checkins[i])
        //                }
        //            }
            List {
                ForEach(0..<min(self.maxDisplayedCheckins, self.checkins.count)){ i in
                    
                    YPDRecentCheckinView(displayedCheckin:
                        self.checkins[i], displayShadow: false).listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
            }.listStyle(DefaultListStyle())
                .navigationBarTitle("Checkin History")
                .onAppear {
//                    UITableView.appearance().separatorStyle = .none
            }.onDisappear {
//                UITableView.appearance().separatorStyle = .singleLine
                
            }
    }
}

struct YPDCheckinsView_Previews: PreviewProvider {
    static var previews: some View {
        YPDCheckinsView(checkins: .init(repeating: _sampleCheckin, count: 200), maxDisplayedCheckins: 10)
    }
}
