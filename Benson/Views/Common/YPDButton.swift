//
//  YPDButton.swift
//  Benson
//
//  Created by Aaron Baw on 30/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
        return Button(action: self.action){
            Text(self.title)
                .font(.headline)
        }.frame(width: geometry.size.width - Constants.Padding * 2, height: 50)
        .foregroundColor(Color(UIColor.white))
//        .padding(.all, Constants.Padding)
        .background(Color.blue)
            .cornerRadius(10)
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
        
        }.frame(height: 50)
    }
}

struct YPDButton_Previews: PreviewProvider {
    static var previews: some View {
        YPDButton(title: "Submit", action: {
            print("Tapped")
            })
    }
}
