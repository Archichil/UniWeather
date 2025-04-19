//
//  UniWeatherWidgetsBundle.swift
//  UniWeatherWidgets
//
//  Created by Daniil on 19.04.25.
//

import WidgetKit
import SwiftUI

@main
struct UniWeatherWidgetsBundle: WidgetBundle {
    var body: some Widget {
        UniWeatherWidgets()
        UniWeatherWidgetsControl()
        UniWeatherWidgetsLiveActivity()
    }
}
