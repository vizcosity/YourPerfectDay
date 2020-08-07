//
//  BensonHealthManager.swift
//  This Class liases with HealthKit in order to retrieve health data such as sleep, activity, and nutritional energy.
//
//  Created by Aaron Baw on 08/12/2019.
//  Copyright © 2019 Ventr. All rights reserved.
//

import Foundation
import HealthKit
import SwiftyJSON
//import Granola

// Checkpoint: About to send BensonHealthDataObjects off to the server; need to run a background job which groups checkins by day, and ensures we have a database entry with a benson health data object which is linked to each of the checkins.
class BensonHealthManager {
    
    var healthStore: HKHealthStore?
    var dispatchGroup: DispatchGroup = DispatchGroup()
    
    static let sharedInstance = BensonHealthManager()
    
    init?(){
                
        if !HKHealthStore.isHealthDataAvailable() {
            return nil
        }

        self.healthStore = HKHealthStore()
        
        self.healthStore?.requestAuthorization(toShare: nil, read: BensonHealthUtil.HKObjectsToRead, completion: { (result, error) in
            print("[BensonHealthManager] Recieved authorization to access health data: \(result)")
            print("[BensonHealthManager] Enriching Checkins with Health Data.")
            self.enrichCheckinsWithHealthData()
        })
        
        
    }
    
    public func enrichCheckinsWithHealthData(){
        // Fetch unenriched checkins and submit pending health data.
        Fetcher.sharedInstance.fetchUnenrichedCheckinDates { (dates) in
            self.log("Fetched unenriched checkin dates: \(dates)")
            BensonHealthManager.sharedInstance?.fetchHealthData(forDays: dates, completionHandler: { (healthDataObjects) in
                self.log("Fetched \(healthDataObjects.count). Submitting these now.")
                Fetcher.sharedInstance.submitHealthDataObjects(healthDataObjects: healthDataObjects) { (result, error) in
                    self.log("Submitted all healthDataObjects. Result: \(String(describing: result)). Error: \(String(describing: error))")
                }
            })
        }
    }

    /// Iteratively fetches healthData for all days passed, returning an array of BensonHealthDataObjects.
    public func fetchHealthData(forDays days: [Date], completionHandler: @escaping ([BensonHealthDataObject]) -> Void) {
        return self.fetchHealthData(forDays: days, accumulatedHealthData: [], completionHandler: completionHandler)
    }
    
    private func fetchHealthData(forDays days: [Date], accumulatedHealthData: [BensonHealthDataObject], completionHandler: @escaping ([BensonHealthDataObject]) -> Void) {
        var days = days.map { $0 }
        guard let day = days.popLast() else { return completionHandler(accumulatedHealthData) }
        self.fetchHealthData(forDay: day) { (healthData) in
            self.fetchHealthData(forDays: days, accumulatedHealthData: accumulatedHealthData + [healthData], completionHandler: completionHandler)
        }
    }
    
    /// Fetches all data for workouts, caloric consumption and output, heart rate, and sleep analysis asynchronously.
    public func fetchHealthData(forDay day: Date, completionHandler: @escaping (BensonHealthDataObject) -> Void) {
        
        var dataObject = BensonHealthDataObject(date: day)
        
        self.fetchSleepHours(forDay: day) { (sleepHours) in
//            self.log("Asleep for \(sleepHours) on \(day)")
            dataObject.sleepHours = sleepHours
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .dietaryEnergyConsumed, withUnit: .kilocalorie()) { (caloricIntake) in
//            self.log("Consumed \(caloricIntake) kCal on \(day)")
            dataObject.caloricIntake = caloricIntake
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .dietaryCarbohydrates, withUnit: .gram()) { (carbGrams) in
//            self.log("Consumed \(carbGrams)g of carbs on \(day)")
            dataObject.dietaryCarbohydrates = carbGrams
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .dietaryProtein, withUnit: .gram()) { (proteinGrams) in
//           self.log("Consumed \(proteinGrams)g of protein on \(day)")
            dataObject.dietaryProtein = proteinGrams
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .dietaryFatTotal, withUnit: .gram()) { (fatGrams) in
//            self.log("Consumed \(fatGrams)g of fat on \(day)")
            dataObject.dietaryFats = fatGrams
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .basalEnergyBurned, withUnit: .kilocalorie()) { (energyBurned) in
//            self.log("Resting energy \(energyBurned) kCal burned on \(day)")
            dataObject.basalEnergyBurned = energyBurned
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .activeEnergyBurned, withUnit: .kilocalorie()) { (energyBurned) in
//            self.log("Active energy \(energyBurned) kCal burned on \(day)")
            dataObject.activeEnergyBurned = energyBurned
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .bodyMass, withUnit: .gramUnit(with: .kilo)) { (weightInKilos) in
            dataObject.weight = weightInKilos
        }
        
        self.fetchWorkoutsPerformed(forDay: day) { (workouts) in
//            workouts.forEach { self.log("Workout \($0.type) burned \($0.energyBurned) kCal after \($0.duration) seconds") }
            dataObject.workouts = workouts
        }
        
        self.fetchAverageQuantityAcrossSources(forDay: day, andQuantityTypeIdentifier: .heartRateVariabilitySDNN, withUnit: .secondUnit(with: .milli)) { (hrv) in
//            self.log("HRV of \(hrv/10) ms on \(day)")
            dataObject.hrv = hrv
        }
        
        self.fetchQuantityAveragedAcrossSources(forDay: day, andQuantityTypeIdentifier: .restingHeartRate, withUnit: HKUnit(from: "count/min")) { (restingHeartRate) in
//            self.log("Resting heart rate of \(restingHeartRate) bpm on \(day)")
            dataObject.restingHeartRate = restingHeartRate
        }
        
        self.fetchLowHeartRateEvents(forDay: day) { (lowHeartRateEvents) in
//            self.log("Obtained \(lowHeartRateEvents) low heart rate events.")
            dataObject.lowHeartRateEvents = lowHeartRateEvents
        }
        
        // Executed once all of our async calls return.
        self.dispatchGroup.notify(queue: .global(qos: .background), execute: {
            completionHandler(dataObject)
//            self.log("All async calls have returned.")
        })
        
        
    }
 
    /// Given an array of samples providing a given quantity across varying sources, groups by the source and then sums across each group.
    func sumQuantityAcrossSources(forSamples samples: [HKSample], forUnit unit: HKUnit) -> Double {
        var quantitiesByGroup: [HKSource: [Double]] = [:]
        samples.forEach { (sample) in
            let source = sample.sourceRevision.source
            if !quantitiesByGroup.keys.contains(source) {
                quantitiesByGroup[source] = []
            }
            if let quantity = sample as? HKQuantitySample {
                quantitiesByGroup[source]?.append(quantity.quantity.doubleValue(for: unit))
            }
        }
        let summedQuantityBygroup = quantitiesByGroup.mapValues { $0.reduce(0) { $0 + $1 }}
        return summedQuantityBygroup.values.reduce(0, +)
    }

    
    /// Given an array of samples providing a given quantity across varying sources, groups by the source and then sums across each group, dividing by the number of groups / sources.
    func sumAndAverageQuantityAcrossSources(forSamples samples: [HKSample], forUnit unit: HKUnit) -> Double {
        var quantitiesByGroup: [HKSource: [Double]] = [:]
        samples.forEach { (sample) in
            let source = sample.sourceRevision.source
            if !quantitiesByGroup.keys.contains(source) {
                quantitiesByGroup[source] = []
            }
            if let quantity = sample as? HKQuantitySample {
                quantitiesByGroup[source]?.append(quantity.quantity.doubleValue(for: unit))
            }
        }
        
        let summedQuantityBygroup = quantitiesByGroup.mapValues { $0.reduce(0) { $0 + $1 }}
        return summedQuantityBygroup.values.reduce(0) { $0 + ($1 / Double(summedQuantityBygroup.values.count)) }
    }
    
    /// Given an array of samples providing a given quantity across varying sources, groups by the source and then averages across each group, dividing by the number of groups / sources.
    func averageQuantityAcrossSources(forSamples samples: [HKSample], forUnit unit: HKUnit) -> Double {
        var quantitiesByGroup: [HKSource: [Double]] = [:]
        samples.forEach { (sample) in
            let source = sample.sourceRevision.source
            if !quantitiesByGroup.keys.contains(source) {
                quantitiesByGroup[source] = []
            }
            if let quantity = sample as? HKQuantitySample {
                quantitiesByGroup[source]?.append(quantity.quantity.doubleValue(for: unit))
            }
        }
        
        let averagedQuantityByGroup = quantitiesByGroup.mapValues { $0.reduce(0) { $0 + $1 } / Double($0.count) }
        return averagedQuantityByGroup.values.reduce(0) { $0 + ($1 / Double(averagedQuantityByGroup.values.count)) }
    }
    
    /// Fetches all workouts performed within the day specified.
    func fetchWorkoutsPerformed(forDay day: Date, completionHandler: @escaping ([BensonWorkout]) -> Void){
        
        let startDate = Calendar.current.startOfDay(for: day)
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startDate)!
        
        // Create a predicate to match everything within the specified date range.
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 100000, sortDescriptors: nil) { (_, samples, error) in
            if let error = error {
                return self.log("Error retrieving workouts on \(day): \(error)")
            }
            
            if let samples = samples as? [HKWorkout] {
                    completionHandler(samples.map { BensonWorkout(fromWorkout: $0) })
                    return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
    }
    
    /// Fetches the active energy burned for the day.
    func fetchActiveEnergy(forDay day: Date, completionHandler: @escaping (Double) -> Void){
//        let startDate = Calendar.current.startOfDay(for: day)
//        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startDate)!
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: day)
        dateComponents.calendar = Calendar.current
        
        let predicate = HKQuery.predicateForActivitySummary(with: dateComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate) { (_, activitySummaries, error) in
            if let error = error {
                return self.log("Error retrieving activity summary: \(error)")
            }
            
            guard let activitySummaries = activitySummaries, activitySummaries.count > 0 else {
                return self.log("Could not fetch activity summaries.")
            }
            
            activitySummaries.forEach { (summary) in
                self.log("Received active energy burned: \(summary.activeEnergyBurned)")
            }
            
        }
        
        self.healthStore?.execute(query)
    }
    
    /// Fetches the number of low heart rate events which occured on that day. This is a good indicator of fatigue.
    func fetchLowHeartRateEvents(forDay day: Date, completionHandler: @escaping (Int) -> Void){
        
//        self.log("Fetching sleep data.")
        
        guard let objectType = HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent) else {
            self.log("Failed to unwrap lowHeartRate HKObjectType optional. Exiting early.")
            return completionHandler(-1)
        }
        
        // Start the query from 5pm on the current day (shouldn't matter if the time has not reached 5pm yet, as we are looking to cover the entire possible range for which the user could have been asleep.
        let endDateComponents = DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, era: nil, year: day.component(.year), month: day.component(.month), day: day.component(.day), hour: 17)
        let endDate = Calendar.current.date(from: endDateComponents)!
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: objectType, predicate: predicate, limit: 100000, sortDescriptors: nil) { (_, samples, error) in
            if let error = error {
                self.log("Could not fetch lowHeartRateEvents: \(error)")
                completionHandler(-1)
                self.dispatchGroup.leave()
            }
            
            if let samples = samples {
//                self.log("Received lowHeartRateSamples: \(samples.count)")
                completionHandler(samples.count)
                return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
        
    }
    
    /// Given a quantity type, and a date, fetches all samples for the given quantity within the day specified by the date, then groups these across all the various contributing sources and returns the average summed value across all source groups.
    func fetchQuantityAveragedAcrossSources(forDay day: Date, andQuantityTypeIdentifier quantityTypeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, completionHandler: @escaping (Double) -> Void){
        
        let startDate = Calendar.current.startOfDay(for: day)
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startDate)!
                
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: predicate, limit: 100000, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                return self.log("Error retrieving \(quantityTypeIdentifier.rawValue): \(error)")
            }
            
            if let samples = samples {
                completionHandler(self.sumAndAverageQuantityAcrossSources(forSamples: samples, forUnit: unit))
                return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
    }
    
    /// Given a quantity type, and a date, fetches all samples for the given quantity within the day specified by the date, then groups these across all the various contributing sources and returns the sum.
    func fetchSummedQuantity(forDay day: Date, andQuantityTypeIdentifier quantityTypeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, completionHandler: @escaping (Double) -> Void){
        
        let startDate = Calendar.current.startOfDay(for: day)
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startDate)!
                
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: predicate, limit: 100000, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                return self.log("Error retrieving \(quantityTypeIdentifier.rawValue): \(error)")
            }
            
            if let samples = samples {
            self.log("Obtained samples for \(quantityTypeIdentifier.rawValue): \(samples)")
                completionHandler(self.sumQuantityAcrossSources(forSamples: samples, forUnit: unit))
                return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
    }
    
    
    /// Given a quantity type, and a date, fetches all samples for the given quantity within the day specified by the date, then groups these across all the various contributing sources and returns the average  value across all source groups.
    func fetchAverageQuantityAcrossSources(forDay day: Date, andQuantityTypeIdentifier quantityTypeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, completionHandler: @escaping (Double) -> Void){
        
        let startDate = Calendar.current.startOfDay(for: day)
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startDate)!
                
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictEndDate)
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: predicate, limit: 100000, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                self.log("Error retrieving \(quantityTypeIdentifier.rawValue): \(error)")
                completionHandler(-1)
                return self.dispatchGroup.leave()
            }
            
            if let samples = samples {
                
                completionHandler(self.averageQuantityAcrossSources(forSamples: samples, forUnit: unit))
                return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
    }
    
    // Constructs a query for sleep data for last night's sleep. Searches through the 5pm - 5pm 24 hour range for sleep data and returns the total amount of hours slept.
    // TODO: We will need to grab sleep data for the day in which the checkin was made, and attach this to the checkin object. This will then need to be relayed to the backend. I will need to architect a schema on the backend to account for sleep data.
    func fetchSleepHours(forDay day: Date, completionHandler: @escaping (Double) -> Void){
        
//        self.log("Fetching sleep data.")
        
        guard let objectType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            self.log("Failed to unwrap sleepAnalysis HKObjectType optional. Exiting early.")
            return completionHandler(-1)
        }
        
        // Start the query from 5pm on the current day (shouldn't matter if the time has not reached 5pm yet, as we are looking to cover the entire possible range for which the user could have been asleep.
        let startDateComponents = DateComponents(calendar: Calendar.current, timeZone: Calendar.current.timeZone, era: nil, year: day.component(.year), month: day.component(.month), day: day.component(.day), hour: 17)
        
        let endDateOptional = Calendar.current.date(from: startDateComponents)
        guard let endDate = endDateOptional else { return completionHandler(-1) }
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)
        
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
                
        let sortDesriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        self.dispatchGroup.enter()
        let query = HKSampleQuery(sampleType: objectType, predicate: predicate, limit: 100000, sortDescriptors: [sortDesriptor]) { (query, samples, error) in
                        
            if let samples = samples {
                completionHandler(self.averageSleepHours(acrossSamplesWithVariedSources: samples))
                return self.dispatchGroup.leave()
            }
        }
        
        self.healthStore?.execute(query)
    
    }
    
    /// Given a sleep sample, determines the duration for which the user was asleep.
    func getAsleepDuration(forSample sample: HKCategorySample) -> Double {
        return self.hoursBetween(start: sample.startDate, andEnd: sample.endDate)
    }
    
    /// Given two dates, calculates the time elapsed between them in hours.
    func hoursBetween(start: Date, andEnd end: Date) -> Double {
        return Double(abs(Int32(start.timeIntervalSince(end)))) / Double(60 * 60)
    }
    
    func sleepHours(forSample sample: HKSample) -> Double {
        guard let asleepCategorySample = sample as? HKCategorySample else { return -1 }
            let sleepHours = self.hoursBetween(start: asleepCategorySample.startDate, andEnd: asleepCategorySample.endDate)
            return sleepHours
    }
    
    func averageSleepHours(acrossSamplesWithVariedSources samples: [HKSample]) -> Double {
       
        // self.log("Obtained sleep samples: \(samples)")
        
        // Filter out the samples so that we only consider time asleep instead of in bed.
        // We also need to consider that the user could have different *sources* for recording sleep (e.g. sleep cycle, or multiple apple watch apps). We need to consolidate across all of these sources.
        let asleepDurations = samples
            .filter { ($0 as? HKCategorySample)?.value == HKCategoryValueSleepAnalysis.asleep.rawValue }
            .map { $0 as! HKCategorySample }
        
        var samplesBySource: [HKSource: [HKCategorySample]] = [:]
        
        // For each asleepDuration sample we need to group it by a given source.
        asleepDurations.forEach { (sample) in
            let source = sample.sourceRevision.source
            if !samplesBySource.keys.contains(source) {
                samplesBySource[source] = []
            }
            samplesBySource[source]?.append(sample)
        }
        
        // self.log("Sleep sample by source: \(samplesBySource)")
        
        // For each source, calculate the aggregated total sleep.
        let sleepDurationBySource = samplesBySource.mapValues {
            $0.reduce(0) { (accumulated, current) -> Double in
                return accumulated + self.sleepHours(forSample: current)
            }
        }
        
        // self.log("Calculated sleep hours for each source: \(sleepDurationBySource)")
        
        // Calculate the average sleep hours across all sources.
        let averageSleepHours = sleepDurationBySource.values.reduce(0) { (accumulated, current) -> Double in
            return accumulated + (current / Double(sleepDurationBySource.values.count))
        }
        
        return averageSleepHours
        
    }
    
    func log(_ message: String){
        print("[Benson Health Manager] \(message)")
    }
    
}
