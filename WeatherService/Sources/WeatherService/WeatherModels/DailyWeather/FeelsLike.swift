//
//  FeelsLike.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct FeelsLike: DecodableType {
    public let day: Double
    public let night: Double
    public let eve: Double
    public let morn: Double
}
