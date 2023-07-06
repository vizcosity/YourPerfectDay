//
//  CardViewModifier.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 11/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var displayShadow: Bool = true
    var innerPadding: CGFloat = Constants.Padding
    var outerPadding: CGFloat = Constants.Padding
    
    func body(content: Content) -> some View {
        content
            .padding(.all, innerPadding)
            .background(colorScheme == .dark ?  Color(.secondarySystemBackground) : Color(.systemBackground))
            .cornerRadius(Constants.defaultCornerRadius)
            .shadow(color: displayShadow ? Constants.shadowColour : .clear, radius: Constants.shadowRadius, x: Constants.shadowX, y: Constants.shadowY)
            .padding([.horizontal], outerPadding)
    }
}

extension View {
    func cardify(displayShadow: Bool = true, innerPadding: CGFloat = Constants.Padding, outerPadding: CGFloat = Constants.Padding) -> some View {
        self.modifier(CardViewModifier(displayShadow: displayShadow, innerPadding: innerPadding, outerPadding: outerPadding))
    }
}

struct CardViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("My Sample Content")
            .cardify()
    }
}
