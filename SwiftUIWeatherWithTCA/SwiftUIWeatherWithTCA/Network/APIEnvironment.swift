//
//  APIEnvironment.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/6/24.
//

import ComposableArchitecture

extension DependencyValues {
    var mainAppEnvironment: MainAPIClient {
        get { self [MainAPIClient.self] }
        set { self [MainAPIClient.self] = newValue }
    }
    
    var foreCastAppEnvironment: ForecastAPIClient {
        get { self [ForecastAPIClient.self] }
        set { self [ForecastAPIClient.self] = newValue }
    }
    
    var cityListAppEnvironment: CityListAPIClient {
        get { self [CityListAPIClient.self] }
        set { self [CityListAPIClient.self] = newValue }
    }
}


