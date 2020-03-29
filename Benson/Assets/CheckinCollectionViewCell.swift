//
//  CheckinCollectionViewCell.swift
//  Benson
//
//  Created by Aaron Baw on 10/09/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

//@IBDesignable
class CheckinCollectionViewCell: UITableViewCell {

    var metricLog: MetricLog? { didSet { draw(metricAttributes: self.metricLog!.metrics ); setTimeSinceLabel(metricLog: self.metricLog!)
        
        } }
        
    
    // Set the background to the secondary background colour.
    
    // Why do we need this?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        // Set the background colour.
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        self.contentView.layer.cornerRadius = 8.0
                
    }
    
    func setTimeSinceLabel(metricLog: MetricLog){
        // Display the time since the log took place.
        if let sinceLabel = self.viewWithTag(1) as? UILabel {
            sinceLabel.text = metricLog.timeSince
            print("[CheckinCollectionViewCell] | Updated label with \(String(describing: sinceLabel.text))")
        }
    }
    
    // Adds metric cell value component child views displaying each of the metric attributes contained in the parameter passed.
    func draw(metricAttributes: [MetricAttribute]){
                
        let verticalOffsetToSuperview: CGFloat  = 30
        let verticalOffsetToPreviousComponent: CGFloat = 10.0
        
        // Array of perviously added cellvalue components which we will reference in order to add appropriate constraints from the bottom anchor of the previously embedded component to the top of the newly embedded component.
        var embeddedComponents : [MetricCellValueComponent] = []
        
        let cellSuperView = self.contentView
        
        // Clear all components that have previously been drawn.
        cellSuperView.subviews.forEach { ($0 as? MetricCellValueComponent)?.removeFromSuperview() }
        
        metricAttributes.forEach {
            attribute in

//            print("Drawing CellValueComponent for attribute: \(attribute.name) [\(attribute.value)/\(MetricAttribute.maxValue)]")

            // Instantiating the cellValueComponent and setting the values.
            let cellValueComponent = createCellValueComponent(fromMetricAttribute: attribute)
            embed(cellValueComponent: cellValueComponent, insideView: cellSuperView)

            // Programmatically add layout constraints.
            // Source: https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/ProgrammaticallyCreatingConstraints.html

            // Ensure we disable autoresizing masks from being converted into layout constraints.
        cellValueComponent.translatesAutoresizingMaskIntoConstraints = false
            
            // If there are no previously embedded cellValueComponents, then we attatch the constraint to the top anchor of the superview. Otherwise, we attach it to the bottom anchor of the *previous* embedded cellValueComponent
            let isFirstComponent = embeddedComponents.count == 0
            let constraintAnchor = isFirstComponent ? cellSuperView.layoutMarginsGuide.topAnchor : embeddedComponents.last!.layoutMarginsGuide.bottomAnchor

            // Add a layout constraint on the top and bottom of the cell.
            cellValueComponent.topAnchor.constraint(equalTo: constraintAnchor, constant: isFirstComponent ? verticalOffsetToSuperview : verticalOffsetToPreviousComponent).isActive = true
                        
            // Ensure the cellValueComponents takes up the entire width.
            cellValueComponent.leftAnchor.constraint(equalTo: cellSuperView.layoutMarginsGuide.leftAnchor).isActive = true
            cellValueComponent.rightAnchor.constraint(equalTo: cellSuperView.layoutMarginsGuide.rightAnchor).isActive = true

//            cellValueComponent.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
            
//            cellValueComponent.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            
//            originOffset += 70
            embeddedComponents.append(cellValueComponent)
            
            
        }

//        // Cleanup: Add a constraint from the last cellValueComponent to the bottom anchor of the superview.
        if let lastComponent = embeddedComponents.last {
//            print("Setting bottom anchor constraint for the last embedded metric attribute: \(lastComponent.type)")
            let constraintAnchor = cellSuperView.layoutMarginsGuide.bottomAnchor
            lastComponent.bottomAnchor.constraint(equalTo: constraintAnchor, constant: -20).isActive = true
        }
        
    }
    
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        setNeedsLayout()
//        setNeedsDisplay()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        newFrame.size.width = size.width
//        layoutAttributes.frame = newFrame
//        return layoutAttributes
//    }
    
//    override func draw(_ rect: CGRect) {
//
//
//    }
    
    func embed(cellValueComponent : MetricCellValueComponent, insideView view: UIView){
         cellValueComponent.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: cellValueComponent.frame.height))
        view.addSubview(cellValueComponent)
    }
    
    func createCellValueComponent(fromMetricAttribute attribute: MetricAttribute) -> MetricCellValueComponent {
        let cellValueComponent = MetricCellValueComponent()
        cellValueComponent.max = attribute.maxValue
        cellValueComponent.currentValue = attribute.value
        cellValueComponent.type = attribute.name
        // TODO: Ensure that we add an average value everytime we create a metric attribute response.
        cellValueComponent.averageValue = attribute.average 
                
        
        
        return cellValueComponent
    }

}


extension CGPoint {
    func offsetBy(x: CGFloat?, y: CGFloat?) -> CGPoint {
        return CGPoint(x: x ?? self.x, y: y ?? self.y)
    }
}
