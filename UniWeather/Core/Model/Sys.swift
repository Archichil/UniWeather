//
//  Sys.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

struct Sys: DecodableType {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String
    let sunrise: Int
    let sunset: Int
}
