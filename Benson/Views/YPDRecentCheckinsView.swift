//
//  YPDRecentCheckinsView.swift
//  Benson
//
//  Created by Aaron Baw on 19/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDRecentCheckinsView: View {
    
    @Binding var checkins: [YPDCheckin]
    
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
                    YPDRecentCheckinView(displayedCheckin: checkin)
                }
            }
            
        }
    }
}

struct YPDRecentCheckinsView_Previews: PreviewProvider {
    static var previews: some View {
        YPDRecentCheckinsView(checkins: .constant([]))
    }
}
