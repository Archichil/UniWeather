//
//  DailyWeather.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

struct DailyWeather: DecodableType {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [WeatherDay]
}
