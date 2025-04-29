//
//  DailyWeatherSmallWidget.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.


import SwiftUI
import WidgetKit
import AppIntents

struct DailyWeatherSmallWidget: Widget {
    let kind: String = "DailyWeatherSmallWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LocationIntent.self,
            provider: DailyWeatherSmallProvider()
        ) { entry in
            DailyWeatherSmallWidgetView(entry: entry)
        }
        .configurationDisplayName("daily weather")
        .description("daily weather")
        .supportedFamilies([.systemSmall])
    }
}
