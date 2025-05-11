//
//  DailyWeatherLargeEntry.swift
//  UniWeather
//
//  Created by Daniil on 4.05.25.
//

import WidgetKit

struct DailyWeatherLargeEntry: TimelineEntry {
    let date: Date
    let dt: Int
    let sunset: Int
    let sunrise: Int
    let location: String
    let icon: String
    let description: String
    let currentTemp: Int
    let tempMin: Int
    let tempMax: Int
    let hourlyItems: [HourlyWeatherHourItem]
    let dailyItems: [WeatherDailyItem]
    let isCurrentLocation: Bool
}

struct WeatherDailyItem {
    let dt: Int
    let overallMinTemp: Int
    let overallMaxTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let icon: String
}
