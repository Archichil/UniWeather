//
//  City.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

struct City: DecodableType {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
