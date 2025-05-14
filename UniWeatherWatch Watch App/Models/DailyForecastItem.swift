//
//  DailyForecastItem.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import Foundation

struct DailyForecastItem {
    let id: UUID = .init()
    let dt: Int
    let icon: String
    let minTemp: Int
    let maxTemp: Int
}
