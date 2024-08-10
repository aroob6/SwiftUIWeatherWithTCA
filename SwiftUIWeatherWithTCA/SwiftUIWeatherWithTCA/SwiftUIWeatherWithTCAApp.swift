//
//  SwiftUIWeatherWithTCAApp.swift
//  SwiftUIWeatherWithTCAApp
//
//  Created by 이보라 on 8/6/24.
//

import SwiftUI
import MainKit
import ComposableArchitecture

@main
struct SwiftUIWeatherWithTCAApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(store: Store(initialState: MainFeature.State()) {
                MainFeature()
            })
        }
    }
}
