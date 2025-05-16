//
//  WindView.swift
//  UniWeather
//
//  Created by Daniil on 15.05.25.
//

import SwiftUI

struct WindView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    
    var body: some View {
        CompassWindView(
            direction: Double(viewModel.currentWeather?.wind.deg ?? 180),
            speed: viewModel.currentWeather?.wind.speed,
            unit: "m/s"
        )
        .frame(width: 150, height: 150)
    }
}
