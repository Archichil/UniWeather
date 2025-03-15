//
//  CurrentWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

// https://openweathermap.org/current
struct CurrentWeather: DecodableType {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
