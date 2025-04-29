//
//  DailyWeatherSmallEntry.swift
//  UniWeather
//
//  Created by Daniil on 30.04.25.
//

import WidgetKit

struct DailyWeatherSmallEntry: TimelineEntry {
    let date: Date
    let temp: Int
    let icon: String
    let location: String
    let minTemp: Int
    let maxTemp: Int
    let items: [DailyWeatherItem]
    let isCurrentLocation: Bool
}

struct DailyWeatherItem: Hashable {
    let dt: Int
    let icon: String
    let minTemp: Int
    let maxTemp: Int
}
