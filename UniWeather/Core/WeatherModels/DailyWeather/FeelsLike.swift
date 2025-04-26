//
//  FeelsLike.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

struct FeelsLike: DecodableType {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
