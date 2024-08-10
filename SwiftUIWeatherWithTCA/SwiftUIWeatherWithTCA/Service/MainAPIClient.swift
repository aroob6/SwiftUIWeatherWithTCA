//
//  MainAPIClient.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/6/24.
//

import Foundation
import ComposableArchitecture
import Combine

struct MainAPIClient {
    var fetchWeather: (WeatherAPI.Request) async throws -> Result<WeatherAPI.Response, APIError>
}

extension MainAPIClient: DependencyKey {
    static let liveValue = MainAPIClient(
        fetchWeather: { request in
            var cancellables = Set<AnyCancellable>()
            
            guard var urlComponents = URLComponents(string: BaseUrl.url + WeatherAPI.path) else {
                throw APIError.urlComponentsError
            }
            
            let parameter: [String : String] = [
                "lat" : request.lat,
                "lon" : request.lon,
                "appid" : request.appid,
                "lang" : request.lang ?? "kr",
                "units": request.units ?? "metric",
                "mode": request.mode ?? "json"
            ]
            
            urlComponents.queryItems = parameter.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            guard let url = urlComponents.url else {
                throw APIError.urlComponentsError
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { element -> Data in
                        guard let response = element.response as? HTTPURLResponse,
                              (200...299).contains(response.statusCode) else {
                            throw URLError(.badServerResponse)
                        }
                        return element.data
                    }
                    .decode(type: WeatherAPI.Response.self, decoder: JSONDecoder())
                    .sink { status in
                        switch status {
                        case .finished: break
                        case .failure(let error):
                            let apiError: APIError
                            if let urlError = error as? URLError {
                                apiError = .etcError(error: urlError)
                            } else if let decodingError = error as? DecodingError {
                                apiError = .decodingError
                            } else {
                                apiError = .dataError
                            }
                            continuation.resume(returning: .failure(apiError))
                        }
                    } receiveValue: { response in
                        continuation.resume(returning: .success(response))
                    }.store(in: &cancellables)
            }
        }
    )
}
