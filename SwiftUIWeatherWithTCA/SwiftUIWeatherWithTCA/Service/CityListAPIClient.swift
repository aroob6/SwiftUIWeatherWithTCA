//
//  CityListAPIClient.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation
import ComposableArchitecture

struct CityListAPIClient {
    var fetchCityList: () async throws -> Result<[CityListAPI.Response], APIError>
}

extension CityListAPIClient: DependencyKey {
    static let liveValue = CityListAPIClient {
        guard let path = CityListAPI.path else { throw APIError.networkError }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            throw APIError.networkError
        }
        
        guard let data = jsonString.data(using: .utf8) else {
                throw APIError.networkError
            }
        
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let info = try JSONDecoder().decode([CityListAPI.Response].self, from: data)
                continuation.resume(returning: .success(info))
            }
            catch {
                
            }
        }
    }
}
