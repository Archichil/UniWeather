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
        .configurationDisplayName("Детальный прогноз")
        .description("Отображает детальную информацию о погоде: текущую температуру, вероятность осадков и силу ветра с динамическим фоном, который меняется в зависимости от погоды и времени суток.")
        .supportedFamilies([.systemSmall])
    }
}
