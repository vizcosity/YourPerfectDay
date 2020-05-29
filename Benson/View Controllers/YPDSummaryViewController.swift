//
//  YPDSummaryViewController.swift
//  Benson
//
//  Created by Aaron Baw on 24/05/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import UIKit
import SwiftUI

class YPDSummaryViewController: UIHostingController<YPDSummaryView> {
    
//    @State var metricLogs: [MetricLog] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: YPDSummaryView(chartData: YPDChartData(attributes: ["generalFeeling"], selectedTimeUnit: .day)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reassign the root view to make use of the @Binding held at this level.
        self.rootView = YPDSummaryView(chartData: YPDChartData(attributes: ["generalFeeling"], selectedTimeUnit: .day))
        
        // Fetch metric logs and assign this to the root view object.
//        Fetcher.sharedInstance.fetchMetricLogs { (metricLogs) in
////            self.metricLogs = metricLogs
////            self.rootView.checkins = self.metricLogs
//            
//            print("Fetched metric logs for summary view controller.")
//        }
    }
    

}
