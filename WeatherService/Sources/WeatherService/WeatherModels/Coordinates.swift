//
//  Coordinates.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct Coordinates: DecodableType, Sendable {
    public let lon: Double
    public let lat: Double

    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
