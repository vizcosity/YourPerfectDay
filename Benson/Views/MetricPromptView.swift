//
//  MetricPromptView.swift
//  Benson
//
//  Created by Aaron Baw on 18/08/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

//@IBDesignable

class MetricPromptView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var actionDelegate: MetricSelectionDelegate?
    
    @IBInspectable var metricTitle: String = "I'm feeling"
   
    var metricId = ""
    var responses: [String] = ["Horrible", "Meh", "Okay", "Not Bad", "Great"]
    
    var selectedResponseIndex: Int?
    
    func createLabel(for title: String, withWeight weight: String, colour: UIColor, ofSize size: CGFloat) -> UILabel {
        // Create a new UILabel and add the 'metricTitle'.
        let metricTitleLabel = UILabel()
        metricTitleLabel.text = title
        metricTitleLabel.textColor = colour
        metricTitleLabel.font = getLabelFont(forWeight: weight, andSize: size)
        metricTitleLabel.frame = CGRect.zero
        metricTitleLabel.sizeToFit()
        return metricTitleLabel
    }
    
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
    
    func createResponseButton(response: String) -> UIButton {
       let button = BensonButton(response: response)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = responses.firstIndex(of: response)!
        button.addTarget(self, action: #selector(onTapHandler(sender:)), for: .touchUpInside)
        return button
    }
    
    func addOrUpdateButtonAndReturnHorizontalOffset(title: String, atHorizontalOffset offset: CGFloat) -> CGFloat {
        let button = createResponseButton(response: title)
        button.frame.origin = CGPoint(x: offset, y: self.frame.height - button.bounds.height)
        if (self.subviews.filter({ (view) -> Bool in
            
            return (view as? UIButton)?.attributedTitle(for: .normal)?.string == button.attributedTitle(for: .normal)?.string
    
        }).count == 0){
            self.addSubview(button)
        }
        return button.bounds.width + button.titleEdgeInsets.right + button.titleEdgeInsets.left
    }
    
    func clearAnySelected(){
        self.subviews.forEach {
            if let button = ($0 as? UIButton){
                clearSelection(forButton: button)
            }
        }
    }
    
    func clearSelection(forButton button: UIButton){
        setButtonDefaultStyling(button: button)
        selectedResponseIndex = nil
    }
    
    @objc func onTapHandler(sender: Any){
        
        print("On tap handler called.")
        
        // Set the button background colour to white, change the text colour to the faded text colour.
        if let button = sender as? UIButton {
            
            // If the button has been selected already, then de-select it.
            if selectedResponseIndex == button.tag {
              return clearSelection(forButton: button)
            }
            
            print("Attempting to call action delegate.")
            // Send an action to the actionDelegate.
            actionDelegate?.didSelectMetric(responseIndex: button.tag, withMetricId: metricId)
         
            // Otherwise, we should select the button, and de-select all others.
            selectedResponseIndex = button.tag
            selectButton(button: button)
            // De-select all other buttons.
            self.subviews.forEach { (subView) in
                if let otherButton = subView as? UIButton {
                    if button != otherButton {
                        setButtonDefaultStyling(button: otherButton)
                    }
                }
            }
            
            
        }
    }
    
    func selectButton(button: UIButton){
//        print("Selecting button with title \(button.currentTitle)")
        button.backgroundColor = Colour.secondary
        button.setTitleColor(Colour.darkText, for: .normal)
        button.setAttributedTitle(getAttributedTitle(forString: button.attributedTitle(for: .normal)!.string, withWeight: "Light", andSize: 18.0, colour: Colour.selectedButtonText), for: .normal)
    }
    
    func setButtonDefaultStyling(button: UIButton){
//        print("De selecting button with title \(button.currentTitle)")
        button.backgroundColor = .clear
          button.setAttributedTitle(getAttributedTitle(forString: button.attributedTitle(for: .normal)!.string, withWeight: "Light", andSize: 18.0, colour: Colour.secondary), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let metricTitleLabel = createLabel(for: self.metricTitle, withWeight: "Medium", colour: Colour.primary, ofSize: 24.0)
//        metricTitleLabel.frame = rect
        metricTitleLabel.frame.origin.y = rect.origin.y
        self.addSubview(metricTitleLabel)
//        metricTitleLabel.drawText(in: rect)
        
        var offset : CGFloat = 0
        responses.forEach { (response) in
             offset += addOrUpdateButtonAndReturnHorizontalOffset(title: response, atHorizontalOffset: offset)
        }
        
        // Using the offset, we can now calculate how much spacing we would need to fill up the entire width of the view.
        let horizontalButtonSpacing = CGFloat(rect.width - offset) / CGFloat(responses.count - 1)
        offset = 0
        
        // Update positions of all the buttons.
        subviews.forEach { (childView) in
            if let button = childView as? UIButton {
                button.frame.origin.x = offset
                offset += button.bounds.width + button.titleEdgeInsets.right + button.titleEdgeInsets.left + horizontalButtonSpacing
            }
        }
        
        
        self.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.width, height: 65)
    }

}

extension MetricPromptView {
    static func == (lhs: MetricPromptView, rhs: MetricPromptView) -> Bool {
        return lhs.metricTitle == rhs.metricTitle && lhs.metricId == rhs.metricId && lhs.responses.elementsEqual(rhs.responses)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let lhs = self
        if let view = object as? UIView, let rhs = view as? MetricPromptView {
             return lhs.metricTitle == rhs.metricTitle && lhs.metricId == rhs.metricId && lhs.responses.elementsEqual(rhs.responses)
        }
        return false
    }
    
}

protocol MetricSelectionDelegate {
    func didSelectMetric(responseIndex: Int, withMetricId metricId: String)
}
