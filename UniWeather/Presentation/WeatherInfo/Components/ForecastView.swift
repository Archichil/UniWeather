//
//  ForecastView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 2.05.25.
//

import SwiftUI

struct ForecastView: View {
    let time: String
    let icon: String
    let temperature: String

    var body: some View {
        VStack(spacing: 12) {
            Text(time)
                .font(.headline)
                .bold()
            WeatherIconView(weatherCode: icon)
                .font(.title2)
                .aspectRatio(contentMode: .fit)
                .frame(height: 35)
            Text("\(temperature)")
                .font(.title3)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ForecastView(time: "00", icon: "01d", temperature: "25")
}
