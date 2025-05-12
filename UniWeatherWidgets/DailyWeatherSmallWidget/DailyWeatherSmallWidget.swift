//
//  DailyWeatherSmallWidget.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.

import AppIntents
import SwiftUI
import WidgetKit

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
        .configurationDisplayName("Прогноз")
        .description("Отображает текущую температуру, погодные условия, местоположение и прогноз на несколько дней с динамическим фоном, который меняется в зависимости от погоды и времени суток.")
        .supportedFamilies([.systemSmall])
    }
}
