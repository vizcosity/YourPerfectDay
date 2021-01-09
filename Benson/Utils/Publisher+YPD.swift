//
//  Publisher+YPD.swift
//  YourPerfectDay
//
//  Created by Aaron Baw on 09/01/2021.
//  Copyright © 2021 Ventr. All rights reserved.
//

import Foundation
import Combine

extension Publisher where Self == URLSession.DataTaskPublisher {
    func tryDecode<T: Decodable, D: TopLevelDecoder>(type: T.Type, decoder: D) -> AnyPublisher<T, YPDNetworkingError> {
        tryMap { (data: Data, response: URLResponse) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode)
            }
//            print(String(data: data, encoding: .utf8) ?? "Corrupted data")
            return try JSONDecoder().decode(T.self, from: data)
        }
        .print()
        .mapError(YPDNetworkingError.mapError(_:))
        .eraseToAnyPublisher()
    }

    func tryDecode<T: Decodable, D: TopLevelDecoder>(decoder: D) -> AnyPublisher<T, YPDNetworkingError> {
        tryMap { (data: Data, response: URLResponse) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw YPDNetworkingError.satusError(statusCode: httpResponse.statusCode)
            }
        
            return try JSONDecoder().decode(T.self, from: data)
        }
//        .print()
        .mapError(YPDNetworkingError.mapError(_:))
        .eraseToAnyPublisher()
    }
}
