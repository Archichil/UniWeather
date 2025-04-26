//
//  HourlyWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

struct HourlyWeather: DecodableType {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherData]
    let city: City
}
