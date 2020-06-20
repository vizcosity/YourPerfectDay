//
//  YPDTabView.swift
//  Benson
//
//  Created by Aaron Baw on 19/06/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDTabBarView: View {
    
    @State var selection: Int = 0
    
    var body: some View {
        
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            TabView(selection: self.$selection) {
                
                // Initialise a summary view with the default general feeling attribute.
                YPDSummaryView(chartData: YPDChartData(attributes: ["generalFeeling"], selectedTimeUnit: .day)).tabItem {
                    VStack {
                        Image(systemName: "rectangle.3.offgrid")
                        Text("Summary")
                    }
                    
                }.tag(1)
                YPDSubmitCheckinView().tabItem {
                    VStack {
                        Image(systemName: "pencil.tip.crop.circle.badge.plus")
                        Text("Checkin")
                    }
                }.tag(2)
            }
        }
    }
}

struct YPDTabView_Previews: PreviewProvider {
    static var previews: some View {
        YPDTabBarView()
    }
}
