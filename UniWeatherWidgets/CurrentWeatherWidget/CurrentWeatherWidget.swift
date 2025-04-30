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
        .configurationDisplayName("Текущая погода")
        .description("Отображает текущую температу, погодные условия, прогноз на день и местоположение с динамическим фоном, который меняется в зависимости от погоды и времени суток.")
        .supportedFamilies([.systemSmall])
    }
}
