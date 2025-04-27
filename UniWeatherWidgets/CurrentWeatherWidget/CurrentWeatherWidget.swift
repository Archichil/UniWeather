//
//  CurrentWeatherWidget.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit
import Intents

struct CurrentWeatherWidget: Widget {
    let kind: String = "CurrentWeatherWigdet"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LocationIntent.self,
            provider: CurrentWeatherProvider()
        ) { entry in
            CurrentWeatherWidgetView(entry: entry)
        }
        .configurationDisplayName("Current weather widget")
        .description("Current weather widget desc")
        .supportedFamilies([.systemSmall])
    }
}
