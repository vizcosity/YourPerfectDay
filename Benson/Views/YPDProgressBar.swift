//
//  YPDProgressBar.swift
//  Benson
//
//  Created by Aaron Baw on 10/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI


struct YPDProgressBar: View {
    
    var progressValue: CGFloat
    
    var colour: Color
    
    var body: some View {
        
        
        
        GeometryReader { geometry in
        
            Rectangle()
                .fill(self.colour)
                .frame(width: geometry.size.width * self.progressValue, height: Constants.defaultProgressBarHeight, alignment: .center)
                .cornerRadius(Constants.defaultCornerRadius)
            .zIndex(1)
            
            YPDProgressBarBackground(colour: self.colour)
            
        }
        .frame(height: Constants.defaultProgressBarHeight)
        
    }
}

struct YPDProgressBarBackground: View {
    
    var colour: Color
    
    var body: some View {
         
         GeometryReader { geometry in
         
             Rectangle()
             .fill(self.colour)
                .frame(width: geometry.size.width, height: Constants.defaultProgressBarHeight, alignment: .center)
                .cornerRadius(Constants.defaultCornerRadius)
             .opacity(0.25)
             .zIndex(0)
             
         }
         .frame(height: Constants.defaultProgressBarHeight)
         
    }
}

struct YPDProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        YPDProgressBar(progressValue: 0.34, colour: Color.blue)
    }
}
