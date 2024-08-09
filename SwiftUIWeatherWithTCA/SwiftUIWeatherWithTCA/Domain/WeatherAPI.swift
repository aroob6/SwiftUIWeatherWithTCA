//
//  WeatherAPI.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/6/24.
//

import Foundation

// MARK: - WeatherAPI
struct WeatherAPI: Codable {
    static let path = "/weather"
    
    struct Request: Codable {
        let lat: String
        let lon: String
        let appid: String
        let units: String?
        let mode: String?
        let lang: String?
    }
    
    struct Response: Codable, Hashable {
        let coord: Coord?
        let weather: [Weather]?
        let base: String?
        let main: Main?
        let visibility: Int?
        let wind: Wind?
        let rain: Rain?
        let clouds: Clouds?
        let dt: Int?
        let sys: Sys?
        let timezone, id: Int?
        let name: String?
        let cod: Int?
    }
}

// MARK: - Clouds
struct Clouds: Codable, Hashable {
    let all: Int?
    
    static func empty() -> Self {
        return Clouds(all: nil)
    }
}

// MARK: - Coord
struct Coord: Codable, Hashable {
    let lon, lat: Double?
    
    static func empty() -> Self {
        return Coord(lon: nil, lat: nil)
    }
}

// MARK: - Main
struct Main: Codable, Hashable {
    let temp, feels_like, temp_min, temp_max: Double?
    let pressure, humidity, sea_level, grnd_level: Int?
    
    static func empty() -> Self {
        return Main(temp: nil, feels_like: nil, temp_min: nil, temp_max: nil, pressure: nil, humidity: nil, sea_level: nil, grnd_level: nil)
    }
    
}

// MARK: - Rain
struct Rain: Codable, Hashable {
    let the1H: Double?
    
    static func empty() -> Self {
        return Rain(the1H: nil)
    }
}

// MARK: - Sys
struct Sys: Codable, Hashable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
    
    static func empty() -> Self {
        return Sys(type: nil, id: nil, country: nil, sunrise: nil, sunset: nil)
    }
}

// MARK: - Weather
struct Weather: Codable, Hashable {
    let id: Int?
    let main, description, icon: String?
    
    static func empty() -> Self {
        return Weather(id: nil, main: nil, description: nil, icon: nil)
    }
    var imageString: String {
        return String(icon?.dropLast() ?? "")
    }
}

// MARK: - Wind
struct Wind: Codable, Hashable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
    
    static func empty() -> Self {
        return Wind(speed: nil, deg: nil, gust: nil)
    }
}


// MARK: - WeatherAPI.Response: EntityResponseProtocol
extension WeatherAPI.Response: EntityResponseProtocol {
    static func == (lhs: WeatherAPI.Response, rhs: WeatherAPI.Response) -> Bool {
        return lhs == rhs
    }
    
    static func null() -> Self {
        return .init(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)
    }
    
    static func empty() -> Self {
        return .init(
            coord: Coord.empty(),
            weather: [],
            base: nil,
            main: Main.empty(),
            visibility: nil,
            wind: Wind.empty(),
            rain: Rain.empty(),
            clouds: Clouds.empty(),
            dt: nil,
            sys: Sys.empty(),
            timezone: nil,
            id: nil,
            name: nil,
            cod: nil
        )
    }
    
    static func mock() -> Self {
        return .init(
            coord: Coord(lon: 10.99, lat: 44.34),
            weather: [Weather(id: 501, main: "Rain", description: "moderate rain", icon: "10d")],
            base: "stations",
            main: Main(temp: 298.48, feels_like: 298.74, temp_min: 297.56, temp_max: 300.05, pressure: 1015, humidity: 64, sea_level: 1015, grnd_level: 933),
            visibility: 10000,
            wind: Wind(speed: 0.62, deg: 349, gust: 1.18),
            rain: Rain(the1H: 3.16),
            clouds: Clouds(all: 100),
            dt: 1661870592,
            sys: Sys(type: 2, id: 2075663, country: "IT", sunrise: 1661834187, sunset: 1661882248),
            timezone: 7200,
            id: 3163858,
            name: "Zocca",
            cod: 200
        )
    }
    
}
