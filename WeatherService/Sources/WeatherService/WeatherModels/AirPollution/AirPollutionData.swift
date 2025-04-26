//
//  AirPollutionData.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct AirPollutionData: DecodableType {
    public let main: MainAQI
    public let components: AirComponents
    public let dt: Int
}
