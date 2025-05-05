//
//  Temperature.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct Temperature: DecodableType, Sendable {
    public let day: Double
    public let min: Double
    public let max: Double
    public let night: Double
    public let eve: Double
    public let morn: Double
}
