//
//  Networking.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 11/10/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import Foundation

enum YPDNetworkingError: Error {
    case decodingError
    case encodingError
    case castingError
    case satusError(statusCode: Int)
    case otherError(error: Error)
    case generatingURLError
    
    static func mapError(_ error: Error) -> Self {
        if let _ = error as? DecodingError {
            return Self.decodingError
        }
        
        return .otherError(error: error)
    }
}
