//
//  HourlyWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct HourlyWeather: DecodableType {
    public let cod: String
    public let message: Int
    public let cnt: Int
    public let list: [WeatherData]
    public let city: City
}
