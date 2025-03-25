//
//  WeatherData.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

struct WeatherData: DecodableType {
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let visibility: Int?
    let pop: Double
    let sys: HourlyWeatherSys
    let dtTxt: String

//    enum CodingKeys: String, CodingKey {
//        case dt, main, weather, clouds, wind, visibility, pop, rain, snow, sys
//        case dtTxt = "dt_txt"
//    }
}
