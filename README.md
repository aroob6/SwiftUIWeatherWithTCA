# SwiftUIWeatherWithTCA
[SwiftUI+TCA] 날씨 앱 프로젝트

### 정보

| 정보 | 기술 |
| --- | --- |
| Language | Swift |
| UI Framework | SwiftUI |
| Design Pattern | TCA |
| 비동기 | Combine |

### 구현 화면

| 메인화면 | 메인화면 | 검색화면 |
| -------- | -------- | -------- |
| <img src = "https://github.com/user-attachments/assets/01407908-2e7e-4011-aef0-9575cf885dc8"> |<img src = "https://github.com/user-attachments/assets/af6e5164-93d2-4194-b8b1-eaceac16b13e">| <img src = "https://github.com/user-attachments/assets/4539c975-b52a-454b-aab4-f7642b543709">

#### MainView 구성

-   검색
    -   검색하면 SearchView 
-   현재 도시 날씨
    -   API: api.openweathermap.org/data/2.5/weather
-   3시간 간격 2일간 기온 표시
    -   API: api.openweathermap.org/data/2.5/forecast
    -   2일 = 48시간, 3시간 간격 -> 16개 데이터 필요
-   5일동안 최저, 최고 기온 표시
    -   API: api.openweathermap.org/data/2.5/forecast
    -   전체 데이터 가져온 후 "00:00:00" 기준으로 최고, 최저기온 표시

-   해당 도시 위치 표시
-   추가정보 (습도, 구름, 바람속도)

#### SearchView 구성

-   프로젝트 내 json파일 가져와서 리스트 표시
-   검색 시 앞글자 기준으로 filter
