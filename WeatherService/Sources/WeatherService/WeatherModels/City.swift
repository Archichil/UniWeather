//
//  City.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct City: DecodableType {
    public let id: Int
    public let name: String
    public let coord: Coordinates
    public let country: String
    public let timezone: Int
    public let sunrise: Int?
    public let sunset: Int?
    public let population: Int
}
