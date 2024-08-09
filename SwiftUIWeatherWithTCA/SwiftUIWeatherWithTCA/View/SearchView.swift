//
//  SearchView.swift
//  SwiftUIWeatherWithTCA
//
//  Created by 이보라 on 8/9/24.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
    var store: StoreOf<MainFeature>
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
        
        if store.filterCityList.isEmpty {
            Text("없는 도시입니다")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
        ForEach(store.filterCityList, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text(item.country ?? "")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ProjectColor.mainColor)
                .onTapGesture {
                    dismissSearch()
                    store.send(.searchItemTap(item))
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
        }
        
    }
}
