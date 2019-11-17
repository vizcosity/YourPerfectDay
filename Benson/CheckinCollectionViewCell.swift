//
//  CheckinCollectionViewCell.swift
//  Benson
//
//  Created by Aaron Baw on 10/09/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

//@IBDesignable
class CheckinCollectionViewCell: UICollectionViewCell {
    
    var metricLog: MetricLog? { didSet { draw(metricAttributes: self.metricLog!.metrics ?? []) } }
        
    // Set the background to the secondary background colour.
    
    // Why do we need this?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Set the background colour.
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        self.contentView.layer.cornerRadius = 8.0
        
        // Display the time since the log took place.
        if let sinceLabel = self.viewWithTag(1) as? UILabel {
            sinceLabel.text = metricLog?.timeSince ?? "a while ago"
        }
                
    }
    
    // Adds metric cell value component child views displaying each of the metric attributes contained in the parameter passed.
    func draw(metricAttributes: [MetricAttribute]){
        
        var originOffset: CGFloat  = 60.0
        
        metricAttributes.forEach {
            attribute in
            
            print("Drawing CellValueComponent for attribute: \(attribute.name) [\(attribute.value)/\(MetricAttribute.maxValue)")
            
            let cellValueComponent = MetricCellValueComponent()
            cellValueComponent.max = MetricAttribute.maxValue
            cellValueComponent.currentValue = attribute.value
            cellValueComponent.type = attribute.name
            
            cellValueComponent.frame = CGRect(origin: self.bounds.origin.offsetBy(x: nil, y: originOffset), size: CGSize(width: self.bounds.width, height: cellValueComponent.frame.height))
                        
            // TODO: Ensure that we add an average value everytime we create a metric attribute response.
            cellValueComponent.averageValue = attribute.average ?? attribute.value
            
            self.addSubview(cellValueComponent)
            
            originOffset += 70
            
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

}


extension CGPoint {
    func offsetBy(x: CGFloat?, y: CGFloat?) -> CGPoint {
        return CGPoint(x: x ?? self.x, y: y ?? self.y)
    }
}
