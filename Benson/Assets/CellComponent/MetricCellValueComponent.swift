//
//  MetricCellValueComponent.swift
//  Benson
//
//  Created by Aaron Baw on 16/11/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import UIKit

//@IBDesignable
class MetricCellValueComponent: UIView {
    

    @IBOutlet var view: UIView!
    
    // We need to declare the view which will hold what we declared in the Xib file here, as ARC would cause it to be garbage collected once the 'xibSetup' funtion returns.
    // Why do we need to make this an implicitly unwrapped optional?
    
    
    var type: String = "Metric" { didSet { self.updateMetricValueLabel() }}
    
    var currentValue: Int = 0 { didSet { self.updateMetricValueLabel(); self.updateProgressBar() }}
    var max: Int = 0 { didSet { self.updateMetricValueLabel(); self.updateProgressBar() }}
    var averageValue: Int = 0 { didSet { self.updateMetricAverageValueLabel() }}
    
    @IBOutlet weak var metricValueLabel: UILabel!
    @IBOutlet weak var metricAverageValueLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func updateProgressBar(){
        print("Updating progress to \((Float(self.currentValue) / Float(self.max)))")
        self.progressBar.progress = (Float(self.currentValue) / Float(self.max))
    }
    
    func updateMetricValueLabel(){
        self.metricValueLabel.text = "\(self.type) \(self.currentValue)/\(self.max)"
    }
    
    func updateMetricAverageValueLabel(){
        self.metricAverageValueLabel.text = "Average \(self.averageValue)/\(self.max)"
    }
    
    // Taken from: https://medium.com/@umairhassanbaig/ios-swift-creating-a-custom-view-with-xib-ace878cd41c5
    func commonInit(){
        Bundle.main.loadNibNamed("MetricCellValueComponent", owner: self, options: nil)
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    
    // We need to implement the initializer so that we can load the XIB and get access to the different outlets which we have linked to this class.
//    Do we need to set the owner of the XIB to this class?
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        configureXib()
        commonInit()
    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureXib()
        commonInit()
    }
    
    
    // Once we load the Xib, we need to add it to the current view.
//    func configureXib(){
//        view = loadViewFromNib()
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        self.addSubview(view)
//    }
    
    // Method which loads the XIB file and attatches its contents as a child of the current view.
    // https://stackoverflow.com/questions/47232724/make-reusable-component-in-xcode-storyboard
//    func loadViewFromNib() -> UIView {
//        let bundle = Bundle.init(for: self.classForCoder)
//        let nib = UINib(nibName: "MetricCellValueComponent", bundle: bundle)
//
//        // Instantiate the Nib and load it as a view.
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//
//        return view
//
//    }

}
