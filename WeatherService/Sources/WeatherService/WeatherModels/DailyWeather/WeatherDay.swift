//
//  WeatherDay.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct WeatherDay: DecodableType {
    public let dt: Int
    public let sunrise: Int
    public let sunset: Int
    public let temp: Temperature
    public let feelsLike: FeelsLike
    public let pressure: Int
    public let humidity: Int
    public let weather: [Weather]
    public let speed: Double
    public let deg: Int
    public let gust: Double
    public let clouds: Int
    public let pop: Double
    public let rain: Double?
}
