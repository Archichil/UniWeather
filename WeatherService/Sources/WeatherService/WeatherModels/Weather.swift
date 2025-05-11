//
//  Weather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct Weather: DecodableType, Sendable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
}
