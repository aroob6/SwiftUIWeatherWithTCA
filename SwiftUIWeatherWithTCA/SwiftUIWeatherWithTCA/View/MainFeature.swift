//
//  MainFeature.swift
//  SwiftUIWeatherWithTCAApp
//
//  Created by 이보라 on 8/6/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    
    @ObservableState
    struct State {
        var isLoading: Bool = false
        var errorMessage: String?
        
        ///검색
        var searchText = ""
        ///전체 cityList
        var cityList: [CityListAPI.Response] = []
        ///filter cityList
        var filterCityList: [CityListAPI.Response] = [.init(id: 1, name: "mock", country: "mmock", coord: .init(lon: 0.0, lat: 0.0))]
        ///보여줄 cityList
        var showCityList: [CityListAPI.Response] = []
        
        ///현재날씨
        var currentWeather: CurrentWeather = .mock()
        ///3시간별 날씨
        var threeHoursInfo: [ThreeHoursInfo] = [.mock()]
        ///5일간 날씨
        var fiveDaysInfo: [FiveDaysInfo] = []
        /// MapView lat, lon
        var mapViewInfo: MapInfo = .mock()
        
        ///추가정보 ex. 습도, 구름, 바람속도
        var additionalInfo: AdditionalInfo = .mock()
    }
    
    enum Action {
        /// 검색
        case searching(String)
        
        /// Search Tap
        case searchItemTap(CityListAPI.Response)
        
        
        /// pagination
        case loadMore(index: Int)
        
        /// CityList API 요청
        case fetchSearchList
        
        /// CityList API 결과
        case fetchSearchListResponse(Result<[CityListAPI.Response], APIError>)
        
        /// 현재날씨 정보 API 요청
        case fetchWeather(WeatherAPI.Request)
        
        /// 현재날씨 정보 API 결과
        case fetchWeatherResponse(Result<WeatherAPI.Response, APIError>)
        
        /// 5일간/3시간 정보 API 요청
        case fetchForeCast(ForecastAPI.Request)
        
        /// 5일간/3시간 정보 API 결과
        case fetchForeCastResponse(Result<ForecastAPI.Response, APIError>)
        
    }
    
    @Dependency(\.mainAppEnvironment) var mainAppEnvironment
    @Dependency(\.foreCastAppEnvironment) var foreCastAppEnvironment
    @Dependency(\.cityListAppEnvironment) var cityListAppEnvironment
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .searching(let searchText):
                state.searchText = searchText
                
                if searchText.isEmpty {
                    state.showCityList = state.cityList.prefix(20).map{$0}
                }
                else {
                    // 보여줄 20개 itme
                    state.showCityList = state.cityList
                        .filter { $0.name?.lowercased().hasPrefix(searchText.lowercased()) ?? false }.prefix(20).map{$0}
                    
                    // 전체 filter item
                    state.filterCityList = state.cityList
                        .filter { $0.name?.lowercased().hasPrefix(searchText.lowercased()) ?? false }
                }
                return .none
                
            case .searchItemTap(let item):
                let lat = String(item.coord?.lat ?? 0)
                let lon = String(item.coord?.lon ?? 0)
                
                let weatherRequest = WeatherAPI.Request(lat: lat , lon: lon, appid: API_KEY.api_key, units: nil, mode: nil, lang: nil)
                let foreCastRequest = ForecastAPI.Request(lat: lat, lon: lon, appid: API_KEY.api_key, units: nil, mode: nil, cnt: nil, lang: nil)
                
                state.searchText = ""
                state.mapViewInfo = .init(name: item.name, lat: item.coord?.lat, lon: item.coord?.lon)
                
                return .run { send in
                    let weatherResult = try await mainAppEnvironment.fetchWeather(weatherRequest)
                    await send(.fetchWeatherResponse(weatherResult))
                    
                    let foreCastResult = try await foreCastAppEnvironment.fetchForecast(foreCastRequest)
                    await send(.fetchForeCastResponse(foreCastResult))
                }
            case .loadMore(let index):
                if state.searchText.isEmpty {
                    state.showCityList.append(contentsOf: state.cityList[index..<index+20])
                }
                else {
                    if state.filterCityList.count > 20 {
                        //검색 후
                        state.showCityList.append(contentsOf: state.filterCityList[index..<index+20])
                    }
                }
                
                return .none
            case .fetchSearchList:
                print("DEBUG: API 요청 > ")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await cityListAppEnvironment.fetchCityList()
                    await send(.fetchSearchListResponse(result))
                }
                
            case let .fetchSearchListResponse(.success(info)):
                print("DEBUG: API 결과 > response = \(info.count)")
                state.isLoading = false
                state.cityList = info
                return .none
                
            case let .fetchSearchListResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
                /// 현재날씨 정보 요청
            case .fetchWeather(let request):
                print("DEBUG: API 요청 > request = \(request)")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await mainAppEnvironment.fetchWeather(request)
                    await send(.fetchWeatherResponse(result))
                }
                
                /// 현재날씨 정보 결과 - 성공
            case let .fetchWeatherResponse(.success(info)):
                print("DEBUG: API 결과 > response = \(info)")
                state.isLoading = false
                state.currentWeather = createCurrentWeather(response: info)
                state.mapViewInfo = .init(name: info.name, lat: info.coord?.lat, lon: info.coord?.lon)
                state.additionalInfo = createAdditinalInfo(response: info)
                return .none
                
                /// 현재날씨 정보 결과 - 실패
            case let .fetchWeatherResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
                /// 5일간/3시간 정보 요청
            case .fetchForeCast(let request):
                print("DEBUG: API 요청 > request = \(request)")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await foreCastAppEnvironment.fetchForecast(request)
                    await send(.fetchForeCastResponse(result))
                }
                
                /// 5일간/3시간 정보 결과 - 성공
            case let .fetchForeCastResponse(.success(info)):
                print("DEBUG: API 결과 > response = \(info)")
                state.isLoading = false
                state.threeHoursInfo = createThreeHoursInfo(response: info)
                state.fiveDaysInfo = createFiveDaysInfo(response: info)
                return .none
                
                /// 5일간/3시간 정보 결과 - 실패
            case let .fetchForeCastResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            }
            
        }
        
    }
    
    
    //현재 날씨 정보
    private func createCurrentWeather(response: WeatherAPI.Response) -> CurrentWeather {
        guard let name = response.name,
              let description = response.weather?.first?.description,
              let temp = response.main?.temp,
              let tempMin = response.main?.temp_min,
              let tempMax = response.main?.temp_max,
              let imageString = response.weather?.first?.imageString
        else { return CurrentWeather.mock() }
        
        
        return .init(
            name: name,
            description: description,
            temp: String(format: "%.1f", temp),
            tempMin: String(format: "%.1f", tempMin),
            tempMax: String(format: "%.1f", tempMax),
            imageString: imageString
        )
    }
    
    //세시간별 날씨 정보
    private func createThreeHoursInfo(response: ForecastAPI.Response) -> [ThreeHoursInfo] {
        var infoList: [ThreeHoursInfo] = []
        
        // 현재 기온 소수점 제거
        let curTemp = MainFeature.State().currentWeather.temp?.components(separatedBy: ".").first
        //현재 시간, 기온, 아이콘 추가
        infoList.append(.init(
            hours: "지금",
            icon: MainFeature.State().currentWeather.imageString,
            temp: curTemp
        ))
        guard let list = response.list else { return [] }
        
        //2일간 - 16개
        for i in 0..<16 {
            infoList.append(
                .init(
                    hours: "\(list[i].hour ?? "")시",
                    icon: list[i].weather?.first?.imageString,
                    temp: String(format: "%.0f", list[i].main?.temp ?? "")
                )
            )
        }
        return infoList
    }
    
    //5일간 날씨 정보
    private func createFiveDaysInfo(response: ForecastAPI.Response) -> [FiveDaysInfo] {
        var infoList: [FiveDaysInfo] = []
        
        guard let list = response.list else { return [] }
        
        let filteredList = list.filter {$0.dtTxt!.contains("00:00:00")}
        
        for i in filteredList {
            infoList.append(
                .init(day: getDayOfWeek(from: i.dtTxt ?? "") ?? "",
                      icon: i.weather?.first?.imageString,
                      tempMax: String(format: "%.0f", i.main?.tempMax ?? ""),
                      tempMin: String(format: "%.0f", i.main?.tempMin ?? "")
                     )
            )
        }
        
        return infoList
    }
    
    func getDayOfWeek(from dt_txt: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        if let date = dateFormatter.date(from: dt_txt) {
            let today = Date()
            
            let calendar = Calendar.current
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            
            if todayComponents == dateComponents {
                return "오늘"
            }
            
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "EEEEE"
            
            let dayOfWeekInKorean = dateFormatter.string(from: date)
            return dayOfWeekInKorean
        }
        return nil
    }
    
    //추가 정보
    private func createAdditinalInfo(response: WeatherAPI.Response) -> AdditionalInfo {
        
        guard let humidity = response.main?.humidity,
              let clouds = response.clouds?.all,
              let wind_speed = response.wind?.speed
        else { return AdditionalInfo.mock() }
        
        
        return .init(
            humidity: String(humidity),
            clouds: String(clouds),
            wind_speed: String(format: "%.2f", wind_speed)
        )
    }
    
}
