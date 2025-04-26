//
//  AirPollution.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct AirPollution: DecodableType {
    public let coord: Coordinates
    public let list: [AirPollutionData]
}
