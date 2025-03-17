//
//  AirPollutionData.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

struct AirPollutionData: DecodableType {
    let main: MainAQI
    let components: AirComponents
    let dt: Int
}
