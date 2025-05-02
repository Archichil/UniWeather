//
//  Coordinates.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

public struct Coordinates: DecodableType {
    public let lon: Double
    public let lat: Double

    public init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
}
