//
//  DetailWeatherEntry.swift
//  UniWeather
//
//  Created by Daniil on 30.04.25.
//

import WidgetKit

struct DetailWeatherEntry: TimelineEntry {
    let date: Date
    let location: String
    let icon: String
    let temp: Int
    let minTemp: Int
    let maxTemp: Int
    let rain: Int
    let wind: Int
    let isCurrentLocation: Bool
}
