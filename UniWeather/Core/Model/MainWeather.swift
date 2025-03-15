//
//  MainWeather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

struct MainWeather: DecodableType {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let seaLevel: Int
    let grndLevel: Int
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}
