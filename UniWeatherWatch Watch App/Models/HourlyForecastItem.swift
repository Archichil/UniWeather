//
//  HourlyForecastItem.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import Foundation

struct HourlyForecastItem {
    let id: UUID = .init()
    let dt: Int
    let icon: String
    let text: String
}
