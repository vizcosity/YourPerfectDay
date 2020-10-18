//
//  YPDCheckinPrompt.swift
//  Benson
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

#if MAIN_APP
/// YPDCheckinPrompts contain a question which the user will need to respond to with a subjective measurement of how they feel with regards to a certain metric, such as `focus`, `energy`, `mood`, etc.
struct YPDCheckinPrompt: Identifiable, Codable {
    
    var id = UUID()
    var type: String
    var readableTitle: String
    var responseOptions: [YPDCheckinResponseOption]
    
    @State var responseValue: YPDCheckinResponseValue = YPDCheckinResponseValue(type: .unknown, value: 0)
    
    init(type: String, readableTitle: String, responseOptions: [YPDCheckinResponseOption]) {
        self.type = type
        self.responseOptions = responseOptions
        self.readableTitle = readableTitle
        
        // Note that @State variables typically live *outside* of the view, which is why the compiler throws an error when trying to assign a value to the state variable from within the initializer.
        self.responseValue = YPDCheckinResponseValue(type: type, value: 0)
    }
    
    /// Given a JSON response from the web api, returns a MetricPrompt object.
    public static func fromJSON(dict: JSON) -> YPDCheckinPrompt {
        
        // Checkpoint: refactoring code to enable easy instantiation of MetricPrompt objects from dictionaries obtained through GET requests to the backend via AlamoFire.
        // NOTE: The metric Id in this instance actually corresponds to the metric type (e.g. generalFeeling, mood, and so on).
        let type: String = dict["metricId"].stringValue
        let readableTitle: String = dict["title"].stringValue
        
        let responsesJSON = dict["responses"].arrayValue
        
        // print("Obtained responseJSON: \(responsesJSON)")
        
        let responseOptions: [YPDCheckinResponseOption] = responsesJSON.map { (responseJSON) -> YPDCheckinResponseOption in
            return YPDCheckinResponseOption(type: type, label: responseJSON["title"].stringValue, value: responseJSON["value"].doubleValue)
        }.filter { $0.type != .unknown }
                
        return YPDCheckinPrompt(type: type, readableTitle: readableTitle, responseOptions: responseOptions)
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "metricId", readableTitle = "title", responseOptions = "responses"
    }
    
    init(from decoder: Decoder) throws {
        guard let checkinPromptContainer = try? decoder.container(keyedBy: CodingKeys.self) else {
            throw YPDNetworkingError.decodingError
        }
                
        self.readableTitle = try checkinPromptContainer.decode(String.self, forKey: .readableTitle)
        self.responseOptions = try checkinPromptContainer.decode([YPDCheckinResponseOption].self, forKey: .responseOptions)
        let type = try checkinPromptContainer.decode(String.self, forKey: .type)
        self.type = type
        self.responseValue = YPDCheckinResponseValue(type: type, value: 0)
    }
}

// Add support for Equatability so that we can find the index of specific checkin prompts.
extension YPDCheckinPrompt: Equatable {
    static func == (lhs: YPDCheckinPrompt, rhs: YPDCheckinPrompt) -> Bool {
        return lhs.id == rhs.id
    }
}
#endif
