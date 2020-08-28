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
    
    var progressBarPadding: CGFloat = 50
    
    @State var animating: Bool = false
    
    var body: some View {
        ZStack {
            Color("YPDSplashScreenBackground")
            VStack {
                Spacer()
                YPDBrandingView()
                YPDAnimatableLoadingBar().padding([.leading, .trailing], progressBarPadding)
                Text("Loading insights.")
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.systemGray6))
                Spacer()
                Spacer()
                
            }.edgesIgnoringSafeArea(.all)
            .opacity(animating ? 1 : 0)
            .animation(.easeInOut(duration:2))

            VStack {
                Spacer()
                Image("YPDAppEntryGraphs")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, animating ? -15 : -400)
                    .animation(Animation.spring(response: 1.4, dampingFraction: 0.7, blendDuration: 3))
            }
        }.edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation {
                self.animating.toggle()
            }
        }
    }
}

struct YPDEntryView_Previews: PreviewProvider {
    static var previews: some View {
        YPDEntryView()
    }
}

struct YPDBrandingView: View {
    
    var body: some View {
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
    }
}
