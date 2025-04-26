//
//  Temperature.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

struct Temperature: DecodableType {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
