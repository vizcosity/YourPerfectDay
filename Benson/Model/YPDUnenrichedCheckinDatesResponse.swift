//
//  YPDUnenrichedCheckinDatesResponse.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 09/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import Foundation

struct YPDUnenrichedCheckinDatesResponse {
    let success: Bool
    let dates: [Date]
}

extension YPDUnenrichedCheckinDatesResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case success
        case dates = "result"
    }
}
