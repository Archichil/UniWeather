//
//  WeatherData.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct WeatherData: DecodableType, Sendable {
    public let dt: Int
    public let main: MainWeather
    public let weather: [Weather]
    public let clouds: Clouds
    public let wind: Wind
    public let rain: Rain?
    public let snow: Snow?
    public let visibility: Int?
    public let pop: Double
    public let sys: HourlyWeatherSys
    public let dtTxt: String

//    enum CodingKeys: String, CodingKey {
//        case dt, main, weather, clouds, wind, visibility, pop, rain, snow, sys
//        case dtTxt = "dt_txt"
//    }
}
