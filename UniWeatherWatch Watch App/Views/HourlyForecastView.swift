//
//  HourlyForecastView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI

private struct HourlyForecastItemView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("12:00")
                .frame(maxWidth: 55, alignment: .leading)
            
            HStack(alignment: .center, spacing: 0) {
                Text("\(24)º")
                    .frame(alignment: .trailing)
                
                WeatherIconView(weatherCode: "02d")
                    .frame(maxWidth: 35, alignment: .trailing)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .font(.system(size: 16))
        .fontWeight(.semibold)
    }
}

struct HourlyForecastView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
                HourlyForecastItemView()
            }
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    ContentView()
}
