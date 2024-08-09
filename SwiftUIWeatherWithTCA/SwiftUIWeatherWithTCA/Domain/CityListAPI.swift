//
//  CityListAPI.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation

struct CityListAPI: Codable {
    static let path = Bundle.main.path(forResource: "citylist", ofType: "json")
    
    struct Response: Codable, Hashable {
        let id: Int?
        let name, country: String?
        let coord: Coord?
    }
}
