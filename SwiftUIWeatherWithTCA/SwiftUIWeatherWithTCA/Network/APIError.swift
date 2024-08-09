//
//  APIError.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/6/24.
//

import Foundation

enum APIError: Error {
    case dataError
    case decodingError
    case networkError
    case etcError(error: Error)
    case urlComponentsError
}
