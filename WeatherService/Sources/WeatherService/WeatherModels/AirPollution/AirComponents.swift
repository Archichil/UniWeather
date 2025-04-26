//
//  AirComponents.swift
//  UniWeather
//
//  Created by Daniil on 16.03.25.
//

import APIClient

public struct AirComponents: DecodableType {
    public let co: Double?
    public let no: Double?
    public let no2: Double?
    public let o3: Double?
    public let so2: Double?
    public let pm2_5: Double?
    public let pm10: Double?
    public let nh3: Double?
}
