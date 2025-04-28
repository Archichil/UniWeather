//
//  WeatherIcon.swift
//  UniWeather
//
//  Created by Daniil on 28.04.25.
//

import SwiftUI

struct WeatherIcon: View {
    static let weatherIconMap: [String: String] = [
        "sunrise": "sunrise.fill",
        "sunset": "sunset.fill",
        "01d": "sun.max.fill",
        "01n": "moon.stars.fill",
        "02d": "cloud.sun.fill",
        "02n": "cloud.moon.fill",
        "03d": "cloud.fill",
        "03n": "cloud.fill",
        "04d": "cloud.fill",
        "04n": "cloud.fill",
        "09d": "cloud.drizzle.fill",
        "09n": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "10n": "cloud.rain.fill",
        "11d": "cloud.bolt.rain.fill",
        "11n": "cloud.bolt.rain.fill",
        "13d": "snowflake",
        "13n": "snowflake",
        "50d": "cloud.fog.fill",
        "50n": "cloud.fog.fill",
    ]

    let weatherCode: String

    var body: some View {
        Image(systemName: WeatherIcon.weatherIconMap[weatherCode] ?? "questionmark")
            .symbolRenderingMode(.multicolor)
    }
}
