//
//  Wind.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

struct Wind: DecodableType {
    let speed: Double
    let deg: Int
    let gust: Double
}
