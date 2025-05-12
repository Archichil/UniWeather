//
//  CurrentWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

// https://openweathermap.org/current
public struct CurrentWeather: DecodableType, Sendable {
    public let coord: Coordinates
    public let weather: [Weather]
    public let base: String
    public let main: MainWeather
    public let visibility: Int
    public let wind: Wind
    public let clouds: Clouds
    public let rain: Rain?
    public let snow: Snow?
    public let dt: Int
    public let sys: CurrentWeatherSys
    public let timezone: Int
    public let id: Int
    public let name: String
    public let cod: Int
}
