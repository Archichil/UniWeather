//
//  MainWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

struct MainWeather: DecodableType {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let seaLevel: Int
    let grndLevel: Int
    let tempKf: Double?
}
