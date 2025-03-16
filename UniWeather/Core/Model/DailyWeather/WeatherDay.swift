//
//  WeatherDay.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

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
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp, pressure, humidity, weather, speed, deg, gust, clouds, pop, rain
        case feelsLike = "feels_like"
    }
}
