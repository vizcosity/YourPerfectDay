//
//  YPDCheckinPrompt.swift
//  Benson
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation
import SwiftUI
//import SwiftyJSON

#if MAIN_APP

struct YPDCheckinPromptSubmissionResponse: Codable {
    let success: Bool
}

/// YPDCheckinPrompts contain a question which the user will need to respond to with a subjective measurement of how they feel with regards to a certain metric, such as `focus`, `energy`, `mood`, etc.
struct YPDCheckinPrompt: Identifiable, Decodable {
    
    var id = UUID()
    var type: String
    var readableTitle: String
    var responseOptions: [YPDCheckinResponseOption]
    
//    var sliderValue: Binding<Float> = .constant(0)
    var responseValue: YPDCheckinResponseValue = YPDCheckinResponseValue(type: .unknown, value: 0)
    
    init(type: String, readableTitle: String, responseOptions: [YPDCheckinResponseOption]) {
        self.type = type
        self.responseOptions = responseOptions
        self.readableTitle = readableTitle
        
        // Note that @State variables typically live *outside* of the view, which is why the compiler throws an error when trying to assign a value to the state variable from within the initializer.
        self.responseValue = YPDCheckinResponseValue(type: type, value: 0)

        // Initialise the slider value property in order to allow for checkin prompt views to change their slider values.
//        self.sliderValue = Binding<Float>(get: { Float(self.responseValue.value) }, set: { self.responseValue.value = Double($0) })
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
//        self.sliderValue = Binding<Float>(get: { Float(self.responseValue.value) }, set: { self.responseValue.value = Double($0) })
    }
}

// Add support for Equatability so that we can find the index of specific checkin prompts.
extension YPDCheckinPrompt: Equatable {
    static func == (lhs: YPDCheckinPrompt, rhs: YPDCheckinPrompt) -> Bool {
        return lhs.id == rhs.id
    }
}
#endif
