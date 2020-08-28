//
//  YPDModel.swift
//  YourPerfectDay
//
//  The YPD Model file contains a singleton object which is shared across all views, containing the available
//  checkin prompts which are displayed to the user.
//
//  Created by Aaron Baw on 20/06/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// Singleton object containing YPDCheckinPrompts.
class YPDModel: ObservableObject {
    
//    static let shared = YPDModel()
    
    @Published var checkinPrompts: [YPDCheckinPrompt] = []
    
    @Published var insightForSelectedAttribute: YPDInsight?

    @Published var insightsForSelectedAttributes: [YPDInsight] = []
    
    var selectedMetricAttribute: YPDCheckinType {
        self.selectedMetricAttributes.first ?? .generalFeeling
    }
    
    @Published var selectedMetricAttributes: [YPDCheckinType] = [.generalFeeling]
    
    @Published var selectedAggregationCriteria: AggregationCriteria = .day
    
    @Published var sliderValues: [Float] = [0]
    
//    public func select(metricAttribute: YPDCheckinType) {
//        self.selectedMetricAttribute = metricAttribute
//        self.fetchInsights()
//    }
    
    public func select(metricAttribute: YPDCheckinType, atIndex index: Int) {
        guard index < self.selectedMetricAttributes.count else { return }
        print("Selecting metric attribute:\(metricAttribute.humanReadable)")
        self.selectedMetricAttributes[index] = metricAttribute
        self.fetchInsights()
    }
    
    public func select(aggregationCriteria: AggregationCriteria) {
        self.selectedAggregationCriteria = aggregationCriteria
        self.fetchInsights()
    }
    
    public func addNewSelectedMetricAttribute(_ metricAttribute: YPDCheckinType? = nil){
        self.selectedMetricAttributes.append(metricAttribute ?? (self.selectedMetricAttributes.last ?? .generalFeeling))
        self.fetchInsights()
    }
    
    public func removeSelectedMetricAttribute(_ metricAttribute: YPDCheckinType? = nil){
        guard self.selectedMetricAttributes.count > 1 else { return }
        if let metricAttribute = metricAttribute {
            self.selectedMetricAttributes = self.selectedMetricAttributes.filter { $0 != metricAttribute }
        } else {
           let _ = self.selectedMetricAttributes.popLast()
        }
    }
    
    init() {
        
        Fetcher.sharedInstance.fetchMetricPrompts(completionHandler: { checkinPrompts in
            DispatchQueue.main.async {
                self.checkinPrompts = checkinPrompts
                self.sliderValues = Array.init(repeating: 0, count: self.checkinPrompts.count)
            }
 
        })
        
        self.fetchInsights()
        
    }
    
    /// Fetches the YPDInsight given the selected metric attribute and aggregation criteria.
    private func fetchInsight() -> Void {
        // Mark the insight as empty so that the views which depend on the insight display progress bars to indicate that the insight is loading. When the insight variable is set, an event should be published which will cause the views to update.
        self.insightForSelectedAttribute = nil
        Fetcher.sharedInstance.fetchInsights(forMetric: self.selectedMetricAttribute, withAggregationCriteria: self.selectedAggregationCriteria, limit: 1, completionHandler: {
            self.insightForSelectedAttribute = $0.first!
            
        })
    }
        
    /// Fetches an insight for every selected metric attribute.
    private func fetchInsights() -> Void {
        
        // Mark the insight as empty so that the views which depend on the insight display progress bars to indicate that the insight is loading. When the insight variable is set, an event should be published which will cause the views to update.
        self.insightsForSelectedAttributes = []
        
        self.selectedMetricAttributes.forEach {
            Fetcher.sharedInstance.fetchInsights(forMetric: $0, withAggregationCriteria: self.selectedAggregationCriteria, limit: 1, completionHandler: {
                if let insight = $0.first {
                    DispatchQueue.main.async {
                        self.insightsForSelectedAttributes.append(insight)
                    }
                }
            })
        }
        

    }
    
    func log(_ msg: String...){
        print("YPDModel |", msg)
    }
    
}
