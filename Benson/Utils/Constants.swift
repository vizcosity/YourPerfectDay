//
//  Constants.swift
//  Benson
//
//  Created by Aaron Baw on 29/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct Constants {
    static let cardPadding: CGFloat = 20
    static let Padding: CGFloat = 20
    static var horizontalButtonMargin: CGFloat = 35
    static var buttonEdgeInsets: CGFloat = 5
    static let defaultProgressBarHeight: CGFloat = 10
    static let defaultProgressBarRadius: CGFloat = 6
    static let defaultCornerRadius: CGFloat = 10
    
    static let shadowColour: Color = Color.black.opacity(0.15)
    
    static let shadowRadius: CGFloat = 5
    static let shadowX: CGFloat = 0
    static let shadowY: CGFloat = 3
}

struct Colour {
    static var primary: UIColor = #colorLiteral(red: 0.9471271634, green: 0.8354215026, blue: 1, alpha: 1)
    static var secondary: UIColor = #colorLiteral(red: 0.6681160927, green: 0.5804412365, blue: 0.7499276996, alpha: 1)
    static var darkText: UIColor = #colorLiteral(red: 0.5621231198, green: 0.4875727296, blue: 0.60321486, alpha: 1)
    static var gradientOne: UIColor = #colorLiteral(red: 0.2296182215, green: 0.0797938332, blue: 0.2422780991, alpha: 1)
    static var gradientTwo: UIColor = #colorLiteral(red: 0.01777612977, green: 0.06035795063, blue: 0.151725024, alpha: 1)
    static var selectedButtonText: UIColor = #colorLiteral(red: 0.1964504421, green: 0.171156913, blue: 0.233199805, alpha: 1)
    
    static var progressBarBlue: Color = .init(red: 90/256, green: 200/256, blue: 250/256)
    static var progresssBarGreen: Color = .init(red: 50/256, green: 215/256, blue: 75/256)
    static var progressBarRed: Color = .init(red: 255/256, green: 59/256, blue: 48/256)
    
    static var chartColours: [UIColor] = [
        #colorLiteral(red: 0.9471271634, green: 0.8354215026, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.7778892305, blue: 0.7389295165, alpha: 1), #colorLiteral(red: 1, green: 0.9256604924, blue: 0.6751254523, alpha: 1), #colorLiteral(red: 0.786677938, green: 1, blue: 0.6851736921, alpha: 1), #colorLiteral(red: 0.7483130105, green: 1, blue: 0.9712234293, alpha: 1), #colorLiteral(red: 0.6818630375, green: 0.8092012222, blue: 1, alpha: 1), #colorLiteral(red: 0.7895013734, green: 0.7520797394, blue: 1, alpha: 1)
    ]
}

struct BackgroundViewWrapper<Children>: View where Children: View {
    var children: () -> Children
    
    // ViewBuilder allows us to access the child views instantiated through the use of a closure. The closure passed as an argument to the initialiser here will outlive the constructor itself (as the child objects can mutate or change), and so this requires the '@escaping' property wrapper.
    init(@ViewBuilder children: @escaping () -> Children){
        self.children = children
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            self.children()
            
        }
    }
}

