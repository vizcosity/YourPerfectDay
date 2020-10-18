//
//  BensonHealthUtil.swift
//  Benson
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import HealthKit

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
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!,
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        
        // New addittions.
        HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
        HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
        HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        HKObjectType.activitySummaryType(),
    ])
}

/// Combined version of a checkin and health data object.
class BensonHealthAndCheckinObject {
    
}

/// Simplified version of the HKWorkout class which provides details of the workout type, duration and number of calories burned.
struct BensonWorkout: Codable, Hashable {
    
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
struct BensonHealthDataObject: Codable, Hashable {
    
    var date: Date
    var startDate: Date
    var endDate: Date
    var sleepHours: Double?
    var caloricIntake: Double?
    var dietaryCarbohydrates: Double?
    var dietaryProtein: Double?
    var dietaryFats: Double?
    var activeEnergyBurned: Double?
    var basalEnergyBurned: Double?
    var weight: Double?
    var workouts: [BensonWorkout]?
    var exerciseMinutes: Double?
    var standingMinutes: Double?
    var stepCount: Double?
    var hrv: Double?
    var restingHeartRate: Double?
    var lowHeartRateEvents: Int?

    
    init (date: Date){
        
        self.date = date
        // By default, all queries are run from the start of the day to the end of the day, with the exception of sleep which is performed
        // from 5pm on the current day to 5pm of the day previously.
        self.startDate = Calendar.current.startOfDay(for: date)
        self.endDate = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startDate)!
        
    }
    
    public func toJSONString() -> String? {
        let encoded = self.toJSON()
        return encoded != nil ? String(data: encoded!, encoding: String.Encoding.utf8) : nil
        
    }
    
    public func toJSON() -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encoded = try? encoder.encode(self)
        return encoded
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
