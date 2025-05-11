//
//  CurrentWeatherEntry.swift
//  UniWeather
//
//  Created by Daniil on 27.04.25.
//

import WidgetKit

struct CurrentWeatherEntry: TimelineEntry {
    let date: Date
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temperature: Int
    let icon: String
    let location: String
    let minTemp: Int
    let maxTemp: Int
    let description: String
    let isCurrentLocation: Bool
}
