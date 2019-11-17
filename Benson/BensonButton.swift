//
//  BensonButton.swift
//  Benson
//
//  Created by Aaron Baw on 29/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

class BensonButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func getLabelFont(forWeight weight: String, andSize size: CGFloat) -> UIFont {
        return UIFont(descriptor: UIFontDescriptor(fontAttributes: [
            UIFontDescriptor.AttributeName.family: "Avenir-\(weight)",
            UIFontDescriptor.AttributeName.textStyle: weight
            ]), size: size)
    }
    
    func getAttributedTitle(forString string: String, withWeight weight: String, andSize size: CGFloat, colour: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.font: getLabelFont(forWeight: weight, andSize: size),
            NSAttributedString.Key.foregroundColor: colour
            ])
    }
    
    func setButtonDefaultStyling(button: UIButton){
        //        print("De selecting button with title \(button.currentTitle)")
        button.backgroundColor = .clear
        button.setAttributedTitle(getAttributedTitle(forString: button.attributedTitle(for: .normal)!.string, withWeight: "Light", andSize: 18.0, colour: Colour.secondary), for: .normal)
    }
    
    convenience init(response: String) {
        self.init()
//        print("Creating a benson button with response: \(response)")
        self.setAttributedTitle(getAttributedTitle(forString: response, withWeight: "Light", andSize: 18.0, colour: Colour.secondary), for: UIControl.State.normal)
        setButtonDefaultStyling(button: self)
        self.layer.cornerRadius = 10.0
        self.titleEdgeInsets = UIEdgeInsets(top: Constants.buttonEdgeInsets, left: Constants.buttonEdgeInsets, bottom: Constants.buttonEdgeInsets, right: Constants.buttonEdgeInsets)
        self.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.sizeToFit()
        self.bounds.size = CGSize(width: self.bounds.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right, height: self.bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
