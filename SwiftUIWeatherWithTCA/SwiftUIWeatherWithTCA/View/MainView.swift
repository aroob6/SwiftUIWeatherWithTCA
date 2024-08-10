//
//  MainView.swift
//  SwiftUIWeatherWithTCAApp
//
//  Created by 이보라 on 8/6/24.
//


import SwiftUI
import ComposableArchitecture
import MapKit

struct MainView: View {
    @Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        NavigationStack {
            weatherView
                .searchable(
                    text: $store.searchText.sending(\.searching),
                    placement: .navigationBarDrawer,
                    prompt: "Search"
                )
                .searchSuggestions {
                    SearchView(store: store)
                }
        }
        
    }
    @ViewBuilder
    private var weatherView: some View {
        ScrollView {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                    
            }
            else {
                currentWeatherView
                threeHoursView
                fiveDaysView
                mapView
                additionalView
            }
            
        }
        .padding()
        .background(ProjectColor.mainColor)
        .onAppear {
            store.send(.fetchSearchList)
            // fetchWeather
            store.send(.fetchWeather(
                WeatherAPI.Request(
                    lat: "36.783611",
                    lon: "127.004173",
                    appid: API_KEY.api_key,
                    units: nil,
                    mode: nil ,
                    lang: nil
                )
            ))
            
            //fetchForeCast
            store.send(.fetchForeCast(
                ForecastAPI.Request(
                    lat: "36.783611",
                    lon: "127.004173",
                    appid: API_KEY.api_key,
                    units: nil,
                    mode: nil,
                    cnt: nil,
                    lang: nil
                )
            ))
        }
    }
    // MARK: - 현재날씨정보
    @ViewBuilder
    private var currentWeatherView: some View {
        VStack {
            Text(store.currentWeather.name ?? "")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            Text("\(store.currentWeather.temp ?? "")°")
                .font(.system(size: 80))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text(store.currentWeather.description ?? "")
                .font(.title2)
                .foregroundStyle(.white)
            Text("최고: \(store.currentWeather.tempMax ?? "0.0")° | 최저: \(store.currentWeather.tempMin ?? "0.0")°")
                .font(.subheadline)
                .foregroundStyle(.white)
        }
        .padding()
    }
    
    // MARK: - 3시간 간격 예보
    @ViewBuilder
    private var threeHoursView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(store.threeHoursInfo) { info in
                        VStack {
                            Text(info.hours ?? "")
                                .foregroundStyle(.white)
                            Image(info.icon ?? "")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("\(info.temp ?? "")°")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(ProjectColor.subColor)
        .cornerRadius(10)
    }
    
    // MARK: - 5일간 간격 예보
    @ViewBuilder
    private var fiveDaysView: some View {
        VStack(alignment: .leading) {
            Text("5일간의 일기예보")
                .foregroundStyle(.white)
            ForEach(store.fiveDaysInfo) { info in
                VStack {
                    Divider()
                    HStack {
                        Text(info.day ?? "")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(info.icon ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Spacer()
                        Text("최소: \(info.tempMin ?? "")°")
                            .foregroundStyle(.white)
                        Text("최대: \(info.tempMax ?? "")°")
                            .foregroundStyle(.white)
                        
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(ProjectColor.subColor)
        .cornerRadius(10)
    }
    
    // MARK: - 도시 위치 표시 (MapView)
    @ViewBuilder
    private var mapView: some View {
        VStack(alignment: .leading) {
            Text("MapView")
                .foregroundStyle(.white)
            Map {
                Marker(store.mapViewInfo.name ?? "", coordinate: CLLocationCoordinate2D(latitude: store.mapViewInfo.lat ?? 0, longitude: store.mapViewInfo.lon ?? 0))
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
        .background(ProjectColor.subColor)
        .cornerRadius(10)
    }
    
    // MARK: - 추가정보 ex 습도, 구름, 바람속도
    @ViewBuilder
    private var additionalView: some View {
        HStack {
            VStack {
                Text("습도")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 10)
                    .foregroundStyle(.white)
                
                Text("\(store.additionalInfo.humidity ?? "")%")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .font(.title)
                    .foregroundStyle(.white)
                Spacer()
                
            }
            .background(ProjectColor.subColor)
            .cornerRadius(10)
            
            VStack {
                Text("구름")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 10)
                    .foregroundStyle(.white)
                
                Text("\(store.additionalInfo.clouds ?? "")%")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .font(.title)
                    .foregroundStyle(.white)
                Spacer()
                
            }
            .background(ProjectColor.subColor)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        
        HStack {
            VStack {
                Text("바람 속도")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading], 10)
                    .foregroundStyle(.white)
                
                Text("\(store.additionalInfo.wind_speed ?? "")m/s")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .font(.title)
                    .foregroundStyle(.white)
                Spacer()
            }
            .background(ProjectColor.subColor)
            .cornerRadius(10)
            
            Rectangle()
                .fill(ProjectColor.mainColor)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
    }
    
}
