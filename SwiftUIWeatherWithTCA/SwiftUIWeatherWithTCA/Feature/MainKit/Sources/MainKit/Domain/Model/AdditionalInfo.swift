//
//  AdditionalInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/7/24.
//

import Foundation
import SupportKit

public struct AdditionalInfo: Codable, Hashable {
    ///습도
    let humidity: String?
    ///구름
    let clouds: String?
    ///바람속도
    let wind_speed: String?
    
}

extension AdditionalInfo: EntityResponseProtocol {
    public static func null() -> Self {
        return .init(humidity: nil, clouds: nil, wind_speed: nil)
    }
    
    public static func empty() -> Self {
        return .init(humidity: "", clouds: "", wind_speed: "")
    }
    
    public static func mock() -> Self {
        return .init(humidity: "56", clouds: "50", wind_speed: "1.97")
    }
    
    
}
