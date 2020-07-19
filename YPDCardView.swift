//
//  YPDCardView.swift
//  Benson
//
//  Created by Aaron Baw on 19/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDCardView<AboveFoldContent: View, MainContent: View, BelowFoldContent: View>: View {
    
    init(@ViewBuilder aboveFold: @escaping () -> AboveFoldContent, @ViewBuilder mainContent: @escaping () -> MainContent, @ViewBuilder belowFold: @escaping () -> BelowFoldContent){
        
        self.aboveFold = aboveFold
        self.mainContent = mainContent
        self.belowFold = belowFold
    }
    
    var aboveFold: () -> AboveFoldContent
    
    var mainContent: () -> MainContent
    
    var belowFold: () -> BelowFoldContent
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                self.aboveFold()
            }.foregroundColor(Color.gray)
            
            VStack {
                    self.mainContent()
            }
            
            // Card below-fold content. (Click for more checkins indicator)
                YPDBelowFoldCardView {
                    self.belowFold()
                }
        }
        .padding(.all, Constants.Padding)
        .background(Color.white)
        .cornerRadius(Constants.defaultCornerRadius)
        .shadow(color: Constants.shadowColour, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
//            .shadow(color: Color.black.opacity(0.15), radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY - 5)
            .padding([.leading, .trailing], Constants.Padding)
        
    }
}

struct YPDDivider: View {
    
    var body: some View {
        Rectangle()
            .fill(Color(red: 225/256, green: 229/256, blue: 233/256))
            .frame(width: nil, height: 1, alignment: .center)
    }
    
}

struct YPDBelowFoldCardView<Content: View>: View {
    
    init(@ViewBuilder _ content: @escaping () -> Content){
        self.content = content
    }
    
    var content: () -> Content
    
    var body: some View {
        
        VStack {
            
            // Horizontal divider.
            YPDDivider()
            
            content()
            
        }
    }
    
}

struct YPDCardView_Previews: PreviewProvider {
    static var previews: some View {
        YPDCardView(aboveFold: {
            VStack {Text("This is my Card!")}
        }, mainContent: {
            VStack {
            Image(systemName: "calendar")
            }
        }, belowFold: {
            HStack {
            Text("Another one bites the dust.")
                .font(.footnote)
            }
        })
    }
}
