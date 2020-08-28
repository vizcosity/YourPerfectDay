//
//  YPDAnimatableLoadingBar.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 23/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDAnimatableLoadingBar: View {
    
    var size: CGFloat = 15
    var paddingFromSides: CGFloat = 50
    var cornerRadius: CGFloat = 15
    var extraSliderSize: CGFloat = 5
    var barOpacity: Double = 0.4
    
    // To be able to animate something, we need to go from one state to another. We can start from the default non-animated state, and then immediately change this when the view appears.
    @State var animating: Bool = true
    
//    var movementComplete: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(barOpacity))
                    .frame(height: size)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                Circle()
                    .frame(width: size + extraSliderSize, height: size + extraSliderSize)
                    .position(x: animating ? geometry.size.width - paddingFromSides : paddingFromSides, y: geometry.size.height / 2)
                    .foregroundColor(.white)
                    .animation(Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true))
            }
        }.frame(height: size + extraSliderSize * 2)
        .onAppear {
            withAnimation {
                self.animating.toggle()
            }
        }
    }
}

struct YPDAnimatableLoadingBar_Previews: PreviewProvider {
    static var previews: some View {
        YPDAnimatableLoadingBar()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
