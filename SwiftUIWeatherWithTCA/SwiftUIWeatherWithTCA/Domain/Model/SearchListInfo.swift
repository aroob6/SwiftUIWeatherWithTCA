//
//  SearchListInfo.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import Foundation
import SupportKit

struct SearchListInfo: Codable, Hashable {
    ///이름
    let name: String?
    ///나라
    let country: String?
}

extension SearchListInfo: EntityResponseProtocol {
    static func null() -> Self {
        return .init(name: nil, country: nil)
    }
    
    static func empty() -> Self {
        return .init(name: "", country: "")
    }
    
    static func mock() -> Self {
        return .init(name: "Asan", country: "kr")
    }
    
    
}
