//
//  WeatherDay.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

struct WeatherDay: DecodableType {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg: Int
    let gust: Double
    let clouds: Int
    let pop: Double
    let rain: Double?
}
