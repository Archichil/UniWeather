//
//  UniWeatherWidgetsBundle.swift
//  UniWeatherWidgets
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

@main
struct UniWeatherWidgetsBundle: WidgetBundle {
    var body: some Widget {
        HourlyWeatherWidget()
        DailyWeatherSmallWidget()
        DetailWeatherWidget()
        CurrentWeatherWidget()
        DailyWeatherLargeWidget()
    }
}
