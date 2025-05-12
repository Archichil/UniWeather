//
//  CurrentWeatherSys.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct CurrentWeatherSys: DecodableType, Sendable {
    public let type: Int?
    public let id: Int?
    public let message: Double?
    public let country: String
    public let sunrise: Int
    public let sunset: Int
}
