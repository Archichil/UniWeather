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
        StaticConfiguration(
            kind: kind,
            provider: HourlyWeatherProvider()
        ) { entry in
            HourlyWeatherWidgetView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Погода сейчас")
        .description("Текущие погодные условия")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
