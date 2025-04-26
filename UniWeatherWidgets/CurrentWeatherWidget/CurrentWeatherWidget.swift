//
//  CurrentWeatherWidget.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit

struct CurrentWeatherWidget: Widget {
    let kind: String = "CurrentWeatherWigdet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: CurrentWeatherProvider()
        ) { entry in
            CurrentWeatherWidgetView()
        }
        .configurationDisplayName("Current weather widget")
        .description("Current weather widget desc")
        .supportedFamilies([.systemSmall])
    }
}
