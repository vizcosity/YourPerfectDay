//
//  GradientView.swift
//  Benson
//
//  Created by Aaron Baw on 18/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

//@IBDesignable
class GradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var enableGradient: Bool = true
    
    func applyGradient(_ view: GradientView){
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [Colour.gradientOne.cgColor, Colour.gradientTwo.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = view.frame
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func draw(_ rect: CGRect) {
        if (self.enableGradient) {
            applyGradient(self)
        }
    }

}
