//
//  AirPollution.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

struct AirPollution: DecodableType {
    let coord: Coordinates
    let list: [AirPollutionData]
}
