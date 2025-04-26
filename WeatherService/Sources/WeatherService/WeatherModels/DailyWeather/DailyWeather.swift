//
//  DailyWeather.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct DailyWeather: DecodableType {
    public let city: City
    public let cod: String
    public let message: Double
    public let cnt: Int
    public let list: [WeatherDay]
}
