//
//  Wind.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct Wind: DecodableType, Sendable {
    public let speed: Double
    public let deg: Int
    public let gust: Double?
}
