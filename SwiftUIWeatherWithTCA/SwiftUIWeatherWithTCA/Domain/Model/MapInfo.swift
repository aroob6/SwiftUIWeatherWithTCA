//
//  MapInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation

struct MapInfo {
    ///이름
    let name: String?
    ///위치
    let lat: Double?
    let lon: Double?
}

extension MapInfo: EntityResponseProtocol {
    static func null() -> MapInfo {
        return .init(name: nil, lat: nil, lon: nil)
    }
    
    static func empty() -> MapInfo {
        return .init(name: "", lat: 0.0, lon: 0.0)
    }
    
    static func mock() -> MapInfo {
        return .init(name: "Asan", lat: 36.7836, lon: 127.0041)
    }
    
    
}
