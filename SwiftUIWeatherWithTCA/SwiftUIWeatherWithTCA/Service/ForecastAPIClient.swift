//
//  ForecastAPIClient.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/7/24.
//

import Foundation
import ComposableArchitecture

struct ForecastAPIClient {
    var fetchForecast: (ForecastAPI.Request) async throws -> Result<ForecastAPI.Response, APIError>
}

extension ForecastAPIClient: DependencyKey {
    static let liveValue = ForecastAPIClient(
        fetchForecast: { request in

            guard var urlComponents = URLComponents(string: BaseUrl.url + ForecastAPI.path) else {
                throw APIError.urlComponentsError
            }
            
            let parameter: [String : String] = [
                "lat" : request.lat,
                "lon" : request.lon,
                "appid" : request.appid,
                "lang" : request.lang ?? "",
                "units": request.units ?? "metric",
                "cnt": request.cnt ?? "",
                "mode": request.mode ?? "json"
            ]
            
            let queryItems = parameter.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                throw APIError.networkError
            }
            
            
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        continuation.resume(returning: .failure(.etcError(error: error)))
                        return
                    }
                    
                    guard let data = data else {
                        continuation.resume(returning: .failure(.dataError))
                        return
                    }
                    
                    do {
                        let foreCastResponse = try JSONDecoder().decode(ForecastAPI.Response.self, from: data)
                        continuation.resume(returning: .success(foreCastResponse))
                    } catch {
                        continuation.resume(returning: .failure(.decodingError))
                    }
                }.resume()
            }
        }
    )
}
