//
//  WeatherIconView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 17.04.25.
//

import SwiftUI

struct WeatherIconView: View {
    static let weatherIconMap: [String: String] = [
        "sunrise": "sunrise.fill",
        "sunset": "sunset.fill",
        "01d": "sun.max.fill",
        "01n": "moon.stars.fill",
        "02d": "cloud.sun.fill",
        "02n": "cloud.moon.fill",
        "03d": "cloud.fill",
        "03n": "cloud.moon.fill",
        "04d": "cloud.fill",
        "04n": "cloud.moon.fill",
        "09d": "cloud.drizzle.fill",
        "09n": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "10n": "cloud.rain.fill",
        "11d": "cloud.sun.bolt.fill",
        "11n": "cloud.moon.bolt.fill",
        "13d": "snowflake",
        "13n": "snowflake",
        "50d": "cloud.fog.fill",
        "50n": "cloud.fog.fill",
    ]

    let weatherCode: String

    var body: some View {
        Image(systemName: WeatherIconView.weatherIconMap[weatherCode] ?? "questionmark")
            .symbolRenderingMode(.multicolor)
    }
}

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 16)], spacing: 20) {
            ForEach(WeatherIconView.weatherIconMap.keys.sorted(), id: \.self) { code in
                VStack(spacing: 8) {
                    Image(systemName: WeatherIconView.weatherIconMap[code]!)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 40))
                    Text(code)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
