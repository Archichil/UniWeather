//
//  AirPollution.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

struct AirPollution: DecodableType {
    let coord: Coordinates
    let list: [AirPollutionData]
}
