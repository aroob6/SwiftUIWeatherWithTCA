//
//  ForecastAPIClient.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/7/24.
//

import Foundation
import ComposableArchitecture
import Combine
import NetworkKit

struct ForecastAPIClient {
    var fetchForecast: (ForecastAPI.Request) async throws -> Result<ForecastAPI.Response, APIError>
}

extension ForecastAPIClient: DependencyKey {
    static let liveValue = ForecastAPIClient(
        fetchForecast: { request in
            var cancellables = Set<AnyCancellable>()
            
            guard var urlComponents = URLComponents(string: BaseUrl.url + ForecastAPI.path) else {
                throw APIError.urlComponentsError
            }
            
            let parameter: [String : String] = [
                "lat" : request.lat,
                "lon" : request.lon,
                "appid" : request.appid ?? API_KEY.api_key,
                "lang" : request.lang ?? "",
                "units": request.units ?? "metric",
                "cnt": request.cnt ?? "",
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
                    .decode(type: ForecastAPI.Response.self, decoder: JSONDecoder())
                    .sink { completion in
                        switch completion {
                        case .finished:
                            break
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
                    }
                    .store(in: &cancellables)
            }
        }
    )
}
