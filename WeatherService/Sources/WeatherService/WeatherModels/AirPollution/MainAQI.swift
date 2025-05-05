//
//  MainAQI.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct MainAQI: DecodableType, Sendable {
    public let aqi: Int
}
