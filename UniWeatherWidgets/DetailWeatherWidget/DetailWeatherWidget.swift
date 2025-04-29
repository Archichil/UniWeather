//
//  DetailWeatherWidget.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.


import SwiftUI
import WidgetKit
import Intents

struct DetailWeatherWidget: Widget {
    let kind: String = "DetailWeatherWigdet"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LocationIntent.self,
            provider: DetailWeatherProvider()
        ) { entry in
            DetailWeatherWidgetView(entry: entry)
        }
        .configurationDisplayName("Detail weather widget")
        .description("Detail weather widget desc")
        .supportedFamilies([.systemSmall])
    }
}
