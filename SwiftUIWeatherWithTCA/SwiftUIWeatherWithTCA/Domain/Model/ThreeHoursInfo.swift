//
//  ThreeHoursInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/7/24.
//

import Foundation

struct ThreeHoursInfo: Codable, Hashable, Identifiable {
    var id = UUID()
    ///시간
    let hours: String?
    ///아이콘
    let icon: String?
    ///기온
    let temp: String?
    
}

extension ThreeHoursInfo: EntityResponseProtocol {
    static func null() -> Self {
        return .init(hours: nil, icon: nil, temp: nil)
    }
    
    static func empty() -> Self {
        return .init(hours: "", icon: .none, temp: "")
    }
    
    static func mock() -> Self {
        return .init(hours: "1", icon: "01", temp: "10")
    }
    
    
}
