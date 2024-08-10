//
//  CityListAPIClient.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation
import ComposableArchitecture
import NetworkKit

struct CityListAPIClient {
    var fetchCityList: () async throws -> Result<[CityListAPI.Response], APIError>
}

extension CityListAPIClient: DependencyKey {
    static let liveValue = CityListAPIClient {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let path = CityListAPI.path else {
                    return continuation.resume(returning: .failure(.urlComponentsError))
                }
                
                guard let jsonString = try? String(contentsOfFile: path) else {
                    return continuation.resume(returning: .failure(.dataError))
                }
                
                guard let data = jsonString.data(using: .utf8) else {
                    return continuation.resume(returning: .failure(.dataError))
                }
                
                let info = try JSONDecoder().decode([CityListAPI.Response].self, from: data)
                continuation.resume(returning: .success(info))
            }
            catch let error {
                return continuation.resume(returning: .failure(.etcError(error: error)))
            }
        }
    }
}
