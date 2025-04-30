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
        }
        .configurationDisplayName("Почасовой прогноз")
        .description("Отображает почасовой прогноз погоды с температурой и погодными условиями, включая информацию времени восхода и заката солнца  динамическим фоном, который меняется в зависимости от погоды и времени суток.")
        .supportedFamilies([.systemMedium])
    }
}
