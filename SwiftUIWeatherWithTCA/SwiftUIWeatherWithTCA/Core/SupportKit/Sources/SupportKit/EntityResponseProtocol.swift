//
//  EntityResponseProtocol.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/6/24.
//

import Foundation

public protocol EntityResponseProtocol: Codable, Hashable {
    static func null() -> Self
    static func empty() -> Self
    static func mock() -> Self
}
