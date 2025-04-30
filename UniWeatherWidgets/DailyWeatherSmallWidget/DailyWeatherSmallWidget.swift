//
//  DailyWeatherSmallWidget.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit

struct DailyWeatherSmallWidget: Widget {
    let kind: String = "DailyWeatherSmallWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DailyWeatherProvider()
        ) { entry in
            DailyWeatherSmallWidgetView()
        }
        .configurationDisplayName("daily weather")
        .description("daily weather")
        .supportedFamilies([.systemSmall])
    }
}
