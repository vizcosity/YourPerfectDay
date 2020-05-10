//
//  YPDProgressBar.swift
//  Benson
//
//  Created by Aaron Baw on 10/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

let _DEFAULT_PROGRESS_BAR_HEIGHT: CGFloat = 10
let _DEFAULT_CORNER_RADIUS: CGFloat = 4

struct YPDProgressBar: View {
    
    var progressValue: CGFloat
    
    var colour: Color
    
    var body: some View {
        
        
        
        GeometryReader { geometry in
        
            Rectangle()
                .fill(self.colour)
                .frame(width: geometry.size.width * self.progressValue, height: _DEFAULT_PROGRESS_BAR_HEIGHT, alignment: .center)
            .cornerRadius(_DEFAULT_CORNER_RADIUS)
            .zIndex(1)
            
            YPDProgressBarBackground(colour: self.colour)
            
        }
        .frame(height: _DEFAULT_PROGRESS_BAR_HEIGHT)
        
    }
}

struct YPDProgressBarBackground: View {
    
    var colour: Color
    
    var body: some View {
         
         GeometryReader { geometry in
         
             Rectangle()
             .fill(self.colour)
             .frame(width: geometry.size.width, height: _DEFAULT_PROGRESS_BAR_HEIGHT, alignment: .center)
             .cornerRadius(_DEFAULT_CORNER_RADIUS)
             .opacity(0.25)
             .zIndex(0)
             
         }
         .frame(height: _DEFAULT_PROGRESS_BAR_HEIGHT)
         
    }
}

struct YPDProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        YPDProgressBar(progressValue: 0.34, colour: Color.blue)
    }
}
