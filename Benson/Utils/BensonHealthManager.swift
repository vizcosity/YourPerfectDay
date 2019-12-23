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

// Struct for managing static data and settings, such as the metrics desired to be read from HealthKit.
struct BensonHealthUtil {
    static var HKObjectsToRead: Set<HKObjectType> = Set([
        HKObjectType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
        HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
        HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        HKObjectType.activitySummaryType(),
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
    ])
}

/// Simplified version of the HKWorkout class which provides details of the workout type, duration and number of calories burned.
class BensonWorkout: Codable {
    
    var type: String = "Workout"
    var duration: TimeInterval
    var energyBurned: Double
    
    init(fromWorkout workout: HKWorkout) {
        self.type = workout.workoutActivityType.description
        self.duration = workout.duration
        self.energyBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
    }
}

class BensonDietaryDataObject: Codable {
    var carbohydrates: Double?
    var protein: Double?
    var fats: Double?
    var calories: Double?
}

/// Container for holding health data obtained from HealthKit.
class BensonHealthDataObject: Codable {
    
    var date: Date
    var startDate: Date
    var endDate: Date
    var sleepHours: Double?
    // var diet: BensonDietaryDataObject?
    var caloricIntake: Double?
    var dietaryCarbohydrates: Double?
    var dietaryProtein: Double?
    var dietaryFats: Double?
    var activeEnergyBurned: Double?
    var basalEnergyBurned: Double?
    var workouts: [BensonWorkout]?
    var hrv: Double?
    var restingHeartRate: Double?
    
    init (date: Date){
        // Checkpoint: Debugging why the dates are not being encoded as proper ISO86061 strings.
        self.date = date
        // By default, all queries are run from the start of the day to the end of the day, with the exception of sleep which is performed
        // from 5pm on the current day to 5pm of the day previously.
        self.startDate = Calendar.current.startOfDay(for: date)
        self.endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startDate)!
        
    }
    
    public func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encoded = try? encoder.encode(self)
        return encoded != nil ? String(data: encoded!, encoding: String.Encoding.utf8) : nil
        
    }
}

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
           
//            let today = Date()
//
//            DispatchQueue.global(qos: .background).async {
//                self.fetchHealthData(forDay: today){
//                    self.log("Fetched health data: \($0.toJSON()!)")
//                }
//            }
        
                            
        })
        
    }
    
    /// Fetches all healthData for an array of dates.
    func fetchHealthData(forDays days: [Date], completionHandler: @escaping ([BensonHealthDataObject]) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        var healthDataObjects: [BensonHealthDataObject] = []
        
        days.forEach { day in
            dispatchGroup.enter()
            self.fetchHealthData(forDay: day) { (healthDataObject) in
                healthDataObjects.append(healthDataObject)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global(qos: .utility)) {
            completionHandler(healthDataObjects)
        }
        
    }
    
    /// Fetches all data for workouts, caloric consumption and output, heart rate, and sleep analysis asynchronously.
    func fetchHealthData(forDay day: Date, completionHandler: @escaping (BensonHealthDataObject) -> Void) {
        
        let dataObject = BensonHealthDataObject(date: day)
        
        self.fetchSleepHours(forDay: day) { (sleepHours) in
//            self.log("Asleep for \(sleepHours) on \(day)")
            dataObject.sleepHours = sleepHours
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .dietaryEnergyConsumed, withUnit: .kilocalorie()) { (caloricIntake) in
//            self.log("Consumed \(caloricIntake) kCal on \(day)")
            dataObject.caloricIntake = caloricIntake
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .dietaryCarbohydrates, withUnit: .gram()) { (carbGrams) in
//            self.log("Consumed \(carbGrams)g of carbs on \(day)")
            dataObject.dietaryCarbohydrates = carbGrams
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .dietaryProtein, withUnit: .gram()) { (proteinGrams) in
//           self.log("Consumed \(proteinGrams)g of protein on \(day)")
            dataObject.dietaryProtein = proteinGrams
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .dietaryFatTotal, withUnit: .gram()) { (fatGrams) in
//            self.log("Consumed \(fatGrams)g of fat on \(day)")
            dataObject.dietaryFats = fatGrams
        }
        
        // TEMP: Testing fetching of active energy burned from the activity summary.
//        self.fetchActiveEnergy(forDay: day) { (activeEnergy) in
//            return
//        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .basalEnergyBurned, withUnit: .kilocalorie()) { (energyBurned) in
//            self.log("Resting energy \(energyBurned) kCal burned on \(day)")
            dataObject.basalEnergyBurned = energyBurned
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .activeEnergyBurned, withUnit: .kilocalorie()) { (energyBurned) in
//            self.log("Active energy \(energyBurned) kCal burned on \(day)")
            dataObject.activeEnergyBurned = energyBurned
        }
        
        self.fetchWorkoutsPerformed(forDay: day) { (workouts) in
//            workouts.forEach { self.log("Workout \($0.type) burned \($0.energyBurned) kCal after \($0.duration) seconds") }
            dataObject.workouts = workouts
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .heartRateVariabilitySDNN, withUnit: .secondUnit(with: .milli)) { (hrv) in
//            self.log("HRV of \(hrv/10) ms on \(day)")
            dataObject.hrv = hrv/10
        }
        
        self.fetchAverageQuantity(forDay: day, andQuantityTypeIdentifier: .restingHeartRate, withUnit: HKUnit(from: "count/min")) { (restingHeartRate) in
//            self.log("Resting heart rate of \(restingHeartRate) bpm on \(day)")
            dataObject.restingHeartRate = restingHeartRate
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
    
    
    /// Given a quantity type, and a date, fetches all samples for the given quantity within the day specified by the date, then groups these across all the various contributing sources and returns the average summed value across all source groups.
    func fetchAverageQuantity(forDay day: Date, andQuantityTypeIdentifier quantityTypeIdentifier: HKQuantityTypeIdentifier, withUnit unit: HKUnit, completionHandler: @escaping (Double) -> Void){
        
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
    
    // Constructs a query for sleep data for last night's sleep. Searches through the 5pm - 5pm 24 hour range for sleep data and returns the total amount of hours slept.
    // TODO: We will need to grab sleep data for the day in which the checkin was made, and attach this to the checkin object. This will then need to be relayed to the backend. I will need to architect a schema on the backend to account for sleep data.
    func fetchSleepHours(forDay day: Date, completionHandler: @escaping (Double) -> Void){
        
        self.log("Fetching sleep data.")
        
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
    
extension Date {
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
}

extension HKWorkoutActivityType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .archery:
           return "archery"
        case .bowling:
           return "bowling"
        case .fencing:
           return "fencing"
        case .gymnastics:
           return "gymnastics"
        case .trackAndField:
           return "trackAndField"
        case .americanFootball:
           return "americanFootball"
        case .australianFootball:
           return "australianFootball"
        case .baseball:
           return "baseball"
        case .basketball:
           return "basketball"
        case .cricket:
           return "cricket"
        case .discSports:
           return "discSports"
        case .handball:
           return "handball"
        case .hockey:
           return "hockey"
        case .lacrosse:
           return "lacrosse"
        case .rugby:
           return "rugby"
        case .soccer:
           return "soccer"
        case .softball:
           return "softball"
        case .volleyball:
           return "volleyball"
        case .preparationAndRecovery:
           return "preparationAndRecovery"
        case .flexibility:
           return "flexibility"
        case .walking:
           return "walking"
        case .running:
           return "running"
        case .wheelchairWalkPace:
           return "wheelchairWalkPace"
        case .wheelchairRunPace:
           return "wheelchairRunPace"
        case .cycling:
           return "cycling"
        case .handCycling:
           return "handCycling"
        case .coreTraining:
           return "coreTraining"
        case .elliptical:
           return "elliptical"
        case .functionalStrengthTraining:
           return "functionalStrengthTraining"
        case .traditionalStrengthTraining:
           return "traditionalStrengthTraining"
        case .crossTraining:
           return "crossTraining"
        case .mixedCardio:
           return "mixedCardio"
        case .highIntensityIntervalTraining:
           return "highIntensityIntervalTraining"
        case .jumpRope:
           return "jumpRope"
        case .stairClimbing:
           return "stairClimbing"
        case .stairs:
           return "stairs"
        case .stepTraining:
           return "stepTraining"
        case .fitnessGaming:
           return "fitnessGaming"
        case .barre:
           return "barre"
        case .dance:
           return "dance"
        case .yoga:
           return "yoga"
        case .mindAndBody:
           return "mindAndBody"
        case .pilates:
           return "pilates"
        case .badminton:
           return "badminton"
        case .racquetball:
           return "racquetball"
        case .squash:
           return "squash"
        case .tableTennis:
           return "tableTennis"
        case .tennis:
           return "tennis"
        case .climbing:
           return "climbing"
        case .equestrianSports:
           return "equestrianSports"
        case .fishing:
           return "fishing"
        case .golf:
           return "golf"
        case .hiking:
           return "hiking"
        case .hunting:
           return "hunting"
        case .play:
           return "play"
        case .crossCountrySkiing:
           return "crossCountrySkiing"
        case .curling:
           return "curling"
        case .downhillSkiing:
           return "downhillSkiing"
        case .snowSports:
           return "snowSports"
        case .snowboarding:
           return "snowboarding"
        case .skatingSports:
           return "skatingSports"
        case .paddleSports:
           return "paddleSports"
        case .rowing:
           return "rowing"
        case .sailing:
           return "sailing"
        case .surfingSports:
           return "surfingSports"
        case .swimming:
           return "swimming"
        case .waterFitness:
           return "waterFitness"
        case .waterPolo:
           return "waterPolo"
        case .waterSports:
           return "waterSports"
        case .boxing:
           return "boxing"
        case .kickboxing:
           return "kickboxing"
        case .martialArts:
           return "martialArts"
        case .taiChi:
           return "taiChi"
        case .wrestling:
           return "wrestling"
        case .other:
           return "other"
        default:
            return "other"
        }
    }
}

class HKWorkoutActivityTypeCaseStatementGenerator {

    // Utility code for generatinc HKWorkout CustomStringConvertible.
    var workoutTypeCaseStrings = """
    case archery
    The constant for shooting archery.
    case bowling
    The constant for bowling
    case fencing
    The constant for fencing.
    case gymnastics
    Performing gymnastics.
    case trackAndField
    Participating in track and field events, including shot put, javelin, pole vaulting, and related sports.
    Team Sports
    case americanFootball
    The constant for playing American football.
    case australianFootball
    The constant for playing Australian football.
    case baseball
    The constant for playing baseball.
    case basketball
    The constant for playing basketball.
    case cricket
    The constant for playing cricket.
    case discSports
    The constant for playing disc sports such as Ultimate and Disc Golf.
    case handball
    The constant for playing handball.
    case hockey
    The constant for playing hockey, including ice hockey, field hockey, and related sports.
    case lacrosse
    The constant for playing lacrosse.
    case rugby
    The constant for playing rugby.
    case soccer
    The constant for playing soccer.
    case softball
    The constant for playing softball.
    case volleyball
    The constant for playing volleyball.
    Exercise and Fitness
    case preparationAndRecovery
    The constant for warm-up, cool down, and therapeutic activities like foam rolling and stretching.
    case flexibility
    The constant for a flexibility workout.
    case walking
    The constant for walking.
    case running
    The constant for running and jogging.
    case wheelchairWalkPace
    The constant for a wheelchair workout at walking pace.
    case wheelchairRunPace
    The constant for wheelchair workout at running pace.
    case cycling
    The constant for cycling.
    case handCycling
    The constant for hand cycling.
    case coreTraining
    The constant for core training.
    case elliptical
    The constant for workouts on an elliptical machine.
    case functionalStrengthTraining
    The constant for strength training, primarily with free weights and body weight.
    case traditionalStrengthTraining
    The constant for strength training exercises primarily using machines or free weights.
    case crossTraining
    The constant for exercise that includes any mixture of cardio, strength, and/or flexibility training.
    case mixedCardio
    The constant for workouts that mix a variety of cardio exercise machines or modalities.
    case highIntensityIntervalTraining
    The constant for high intensity interval training.
    case jumpRope
    The constant for jumping rope.
    case stairClimbing
    The constant for workouts using a stair climbing machine.
    case stairs
    The constant for running, walking, or other drills using stairs (for example, in a stadium or inside a multilevel building)
    case stepTraining
    The constant for training using a step bench.
    case fitnessGaming
    The constant for playing fitness-based video games.
    Studio Activities
    case barre
    The constant for barre workout.
    case dance
    The constant for dancing.
    case yoga
    The constant for practicing yoga.
    case mindAndBody
    The constant for performing activities like Qigong or meditation.
    case pilates
    The constant for a pilates workout.
    Racket Sports
    case badminton
    The constant for playing badminton.
    case racquetball
    The constant for playing racquetball.
    case squash
    The constant for playing squash.
    case tableTennis
    The constant for playing table tennis.
    case tennis
    The constant for playing tennis.
    Outdoor Activities
    case climbing
    The constant for climbing.
    case equestrianSports
    The constant for activities that involve riding a horse, including polo, horse racing, and horse riding.
    case fishing
    The constant for fishing.
    case golf
    The constant for playing golf.
    case hiking
    The constant for hiking.
    case hunting
    The constant for hunting.
    case play
    The constant for play-based activities like tag, dodgeball, hopscotch, tetherball, and playing on a jungle gym.
    Snow and Ice Sports
    case crossCountrySkiing
    The constant for cross country skiing.
    case curling
    The constant for curling.
    case downhillSkiing
    The constant for downhill skiing.
    case snowSports
    The constant for a variety of snow sports, including sledding, snowmobiling, or building a snowman.
    case snowboarding
    The constant for snowboarding.
    case skatingSports
    The constant for skating activities, including ice skating, speed skating, inline skating, and skateboarding.
    Water Activities
    case paddleSports
    The constant for canoeing, kayaking, paddling an outrigger, paddling a stand-up paddle board, and related sports.
    case rowing
    The constant for rowing.
    case sailing
    The constant for sailing.
    case surfingSports
    The constant for a variety of surf sports, including surfing, kite surfing, and wind surfing.
    case swimming
    The constant for swimming.
    case waterFitness
    The constant for aerobic exercise performed in shallow water.
    case waterPolo
    The constant for playing water polo.
    case waterSports
    The constant for a variety of water sports, including water skiing, wake boarding, and related activities.
    Martial Arts
    case boxing
    The constant for boxing.
    case kickboxing
    The constant for kickboxing.
    case martialArts
    The constant for practicing martial arts.
    case taiChi
    The constant for tai chi.
    case wrestling
    The constant for wrestling.
    Other Activities
    case other
    The constant for a workout that does not match any of the other workout activity types.
    """

    func generateCaseStatementsForParsingWorkoutTypes(source: String) -> String {
        var caseStatements = "switch self {\n"
        let pattern = "case \\w*"
        let range = Range(uncheckedBounds: (lower: 0, upper: source.count - 1))
        let regex = try? NSRegularExpression(pattern: pattern)
        regex?.matches(in: source, options: [], range: NSRange(range)).forEach {
            let lowerBound = source.index(source.startIndex, offsetBy: $0.range.lowerBound)
            let upperBound = source.index(source.startIndex, offsetBy: $0.range.upperBound)
            let substring = source[lowerBound...upperBound]
                .replacingOccurrences(of: "case", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
            caseStatements = "  \(caseStatements)\ncase .\(substring):\n   return \"\(substring)\""
        }
        return "\(caseStatements)\n}"
    }
}
