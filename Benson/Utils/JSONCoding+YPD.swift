//
//  JSONCoding+YPD.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 09/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static var ypdDateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = DateFormatter.ypdDateFormatter.date(from: dateString) else { throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "")) }
            return date
        }
    }
}

extension JSONDecoder {
    static var withYPDDateDecoding: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .ypdDateDecodingStrategy
        return decoder
    }
}
