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
    
    @ObservedObject var model: YPDModel = YPDModel()
    
    var initialChartData: YPDChartData = YPDChartData(attributes: [.generalFeeling], selectedTimeUnit: .day)
    
    var body: some View {
        
        ZStack {
                    
            TabView(selection: self.$selection) {
                
                // Initialise a summary view with the default general feeling attribute.
                YPDSummaryView(chartData: initialChartData).tabItem {
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
            
            // Display the entry view while items are loading.
                YPDEntryView()
                    .opacity(model.checkinPrompts.count == 0 ? 1 : 0)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
        // Not ideal, but because of our current setup we need to pass the environment object in here.
        }.environmentObject(model)
    }
}

struct YPDTabView_Previews: PreviewProvider {
    static var previews: some View {
        YPDTabBarView()
    }
}
