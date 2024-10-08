//
//  MapInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation
import SupportKit

public struct MapInfo {
    ///이름
    let name: String?
    ///위치
    let lat: Double?
    let lon: Double?
}

extension MapInfo: EntityResponseProtocol {
    public static func null() -> MapInfo {
        return .init(name: nil, lat: nil, lon: nil)
    }
    
    public static func empty() -> MapInfo {
        return .init(name: "", lat: 0.0, lon: 0.0)
    }
    
    public static func mock() -> MapInfo {
        return .init(name: "Asan", lat: 36.7836, lon: 127.0041)
    }
    
    
}
