//
//  DetailWeatherWidget.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit

struct DetailWeatherWidget: Widget {
    let kind: String = "CurrentWeatherWigdet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DetailWeatherProvider()
        ) { entry in
            DetailWeatherWidgetView()
        }
        .configurationDisplayName("Detail weather widget")
        .description("Detail weather widget desc")
        .supportedFamilies([.systemSmall])
    }
}
