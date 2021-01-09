//
//  YPDCardView.swift
//  Benson
//
//  Created by Aaron Baw on 19/07/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import SwiftUI

struct YPDCardView<AboveFoldContent: View, MainContent: View, BelowFoldContent: View>: View {

    @Environment(\.colorScheme) var colorScheme
    
    init(@ViewBuilder aboveFold: @escaping () -> AboveFoldContent? = { nil }, @ViewBuilder mainContent: @escaping () -> MainContent, @ViewBuilder belowFold: @escaping () -> BelowFoldContent? = { nil }, displayShadow: Bool = true, hideBelowFoldSeparator: Bool = false){
        
        self.aboveFoldContent = aboveFold
        self.mainContent = mainContent
        self.belowFoldContent = belowFold
        self.displayShadow = displayShadow
        self.hideBelowFoldSeparator = hideBelowFoldSeparator
        
    }
    
    var aboveFoldContent: () -> AboveFoldContent?
    
    var mainContent: () -> MainContent
    
    var belowFoldContent: () -> BelowFoldContent?
    
    var displayShadow: Bool

    /// Determines whether or not we should display the below-fold-separator.
    var hideBelowFoldSeparator: Bool
    
    var body: some View {
        
        VStack {
            
            if self.aboveFoldContent() != nil {
                HStack {
                    Spacer()
                    self.aboveFoldContent()
                }.foregroundColor(Color(.secondaryLabel))
            }
            
            VStack {
                self.mainContent()
            }.foregroundColor(.primary)
            
            // Card below-fold content. (Click for more checkins indicator)
            if self.belowFoldContent() != nil && !self.hideBelowFoldSeparator {
                YPDBelowFoldCardView {
                    self.belowFoldContent()!
                }
            }
            
        }
        .padding(.all, Constants.Padding)
        .background(colorScheme == .dark ?  Color(.secondarySystemBackground) : Color(.systemBackground))
        .cornerRadius(Constants.defaultCornerRadius)
        .shadow(color: self.displayShadow ? Constants.shadowColour : .clear, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
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
            Divider()
            
            content()
                .foregroundColor(.secondary)
            
        }
    }
    
}

struct YPDCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
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
            }).environment(\.colorScheme, .dark)
            
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
                      }, hideBelowFoldSeparator: true)
        }
    }
}
