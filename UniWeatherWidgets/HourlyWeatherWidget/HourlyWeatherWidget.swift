//
//  HourlyWeatherWidget.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

struct HourlyWeatherWidget: Widget {
    let kind: String = "HorlyWeatherWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LocationIntent.self,
            provider: HourlyWeatherProvider()
        ) { entry in
            HourlyWeatherWidgetView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Hourly widget")
        .description("HourlyWeatherWidget desc")
        .supportedFamilies([.systemMedium])
    }
}
