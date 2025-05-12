//
//  DailyWeatherLargeWidget.swift
//  UniWeather
//
//  Created by Daniil on 4.05.25.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DailyWeatherLargeWidget: Widget {
    let kind: String = "DailyWeatherLargeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: LocationIntent.self,
            provider: DailyWeatherLargeProvider()
        ) { entry in
            DailyWeatherLargeWidgetView(entry: entry)
        }
        .configurationDisplayName("Прогноз")
        .description("Отображает местоположение текущую температуру и погодные условия, почасовой прогноз и прогноз на несколько дней с динамическим фоном, который меняется в зависимости от погоды и времени суток.")
        .supportedFamilies([.systemLarge])
    }
}
