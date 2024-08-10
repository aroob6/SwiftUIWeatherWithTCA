//
//  CityListAPI.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation
import SupportKit

public struct CityListAPI: Codable {
    
    static let path = Bundle.supportModule.path(forResource: "citylist", ofType: "json")
//    static let path = Bundle.main.path(forResource: "citylist", ofType: "json")
    
    
    public struct Response: Codable, Hashable {
        let id: Int?
        let name, country: String?
        let coord: Coord?
    }
}
