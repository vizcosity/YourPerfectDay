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
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Checkin History")
                    .font(.headline)
                Spacer()
            }.padding([.leading, .top, .trailing], Constants.Padding)
            
            ScrollView {
                ForEach(0..<self.checkins.count) { (i) -> YPDRecentCheckinView in
                    YPDRecentCheckinView(displayedCheckin: self.checkins[i])
                }
            }
            
        }
    }
}

struct YPDCheckinsView_Previews: PreviewProvider {
    static var previews: some View {
        YPDCheckinsView(checkins: .init(repeating: _sampleCheckin, count: 2))
    }
}
