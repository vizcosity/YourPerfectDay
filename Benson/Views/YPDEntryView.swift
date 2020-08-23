//
//  YPDEntryView.swift
//  YourPerfectDay
//  Entry view which displays an animation while the insights and checkins are being loaded.
//
//  Created by Aaron Baw on 17/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDEntryView: View {
    var body: some View {
        ZStack {
            Color("YPDSplashScreenBackground")
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                Text("Your")
                    .kerning(-3)
                    .padding(-10)

                Text("Perfect")
                    .kerning(-3)
                    .padding(-10)

                Text("Day")
                    .kerning(-3)
                    .padding(-10)

                }
                    .font(.system(size: 70, weight: .bold, design: .default))
//                    .bold()
                    .lineSpacing(-10)
                    .foregroundColor(.white)
                Spacer()
                Image("YPDAppEntryGraphs")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
            
            }.edgesIgnoringSafeArea(.all)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct YPDEntryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDEntryView()
    }
}
