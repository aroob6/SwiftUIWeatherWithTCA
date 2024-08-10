//
//  FiveDaysInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/8/24.
//

import Foundation
import SupportKit

struct FiveDaysInfo: Codable, Hashable, Identifiable {
    var id = UUID()
    ///요일
    let day: String?
    ///아이콘
    let icon: String?
    ///최고 기온
    let tempMax: String?
    ///최저 기온
    let tempMin: String?
}

extension FiveDaysInfo: EntityResponseProtocol {
    static func null() -> Self {
        return .init(day: nil, icon: nil, tempMax: nil, tempMin: nil)
    }
    
    static func empty() -> FiveDaysInfo {
        return .init(day: "", icon: "", tempMax: "", tempMin: "")
    }
    
    static func mock() -> FiveDaysInfo {
        return .init(day: "월", icon: "01", tempMax: "10", tempMin: "11")
    }
    
    
}
