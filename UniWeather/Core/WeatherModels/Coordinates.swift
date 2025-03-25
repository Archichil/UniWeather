//
//  Coordinates.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

struct Coordinates: DecodableType {
    let lon: Double
    let lat: Double

    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
