//
//  HourlyWeatherEntry.swift
//  UniWeather
//
//  Created by Daniil on 29.04.25.
//

import WidgetKit

struct HourlyWeatherEntry: TimelineEntry {
    let date: Date
    let dt: Int
    let location: String
    let icon: String
    let description: String
    let temp: Int
    let minTemp: Int
    let maxTemp: Int
    let sunrise: Int
    let sunset: Int
    let items: [HourlyWeatherHourItem]
    let isCurrentLocation: Bool
}

struct HourlyWeatherHourItem: Identifiable {
    let id: UUID = .init()
    let dt: Int
    let icon: String
    let temp: Int
    var isSunsetOrSunrise: Bool = false
}
