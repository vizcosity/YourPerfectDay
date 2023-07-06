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
    
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
        
    @Published var checkinPrompts: [YPDCheckinPrompt] = []
    @Published var insightForSelectedAttribute: YPDInsight?
    @Published var insightsForSelectedAttributes: [YPDInsight] = []
    var selectedMetricAttribute: YPDCheckinType {
        self.selectedMetricAttributes.first ?? .generalFeeling
    }
    @Published var selectedMetricAttributes: [YPDCheckinType] = [.generalFeeling]
    @Published var selectedAggregationCriteria: AggregationCriteria = .day
    @Published var sliderValues: [Float] = [0]
    
    public func select(metricAttribute: YPDCheckinType, atIndex index: Int) {
        guard index < self.selectedMetricAttributes.count else { return }
        print("[YPD Model] | Selecting metric attribute:\(metricAttribute.humanReadable) at index \(index)")
        self.selectedMetricAttributes[index] = metricAttribute
        self.fetchInsights()
    }
    
    public func select(aggregationCriteria: AggregationCriteria) {
        self.selectedAggregationCriteria = aggregationCriteria
        print("[YPD Model] | Selected aggregation criteria: \(aggregationCriteria.humanReadable). Fetching insights now.")
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
        
          Fetcher
            .sharedInstance
            .fetchMetricPrompts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (error) in
                self?.log("Could not fetch metric prompts using Combine: \(error)")
            } receiveValue: { (checkinPrompts) in
                self.checkinPrompts = checkinPrompts
                self.sliderValues = Array.init(repeating: 0, count: self.checkinPrompts.count)
            }
            .store(in: &subscriptions)

        
        self.fetchInsights()
        
    }
        
    /// Fetches an insight for every selected metric attribute.
    private func fetchInsights() -> Void {

        // Mark the insight as empty so that the views which depend on the insight display progress bars to indicate that the insight is loading. When the insight variable is set, an event should be published which will cause the views to update.
        self.insightsForSelectedAttributes = []

        selectedMetricAttributes
            .publisher
            .flatMap { checkinType in Fetcher.sharedInstance.fetchInsights(forMetric: checkinType, withAggregationCriteria: self.selectedAggregationCriteria, limit: 1) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { error in print("[YPDModel] \(#function) fetching insights with completion: \(error)") },
                receiveValue: { insights in
                    guard let insight = insights.first else { return }
                    self.insightsForSelectedAttributes.append(insight)
                }
            )
            .store(in: &subscriptions)


    }
//    private func fetchInsights() {
//        self.insightsForSelectedAttributes = []
//
//        selectedMetricAttributes
//            .publisher
//            .flatMap { checkinType in Fetcher.sharedInstance.fetchInsights(forMetric: checkinType, withAggregationCriteria: self.selectedAggregationCriteria, limit: 1) }
//            .receive(on: DispatchQueue.main)
//            .sink(
//                receiveCompletion: { _ in },
//                receiveValue: { insights in
//                    guard let insight = insights.first else { return }
//                    self.insightsForSelectedAttributes.append(insight)
//                }
//            )
//            .store(in: &subscriptions)
//
//
//    }
    
    func log(_ msg: String...){
        print("YPDModel |", msg)
    }
    
}
