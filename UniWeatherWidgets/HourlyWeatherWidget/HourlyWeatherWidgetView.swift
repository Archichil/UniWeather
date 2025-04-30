//
//  HourlyWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

private struct HourlyWeatherItem: View {
    var time: String
    var icon: String
    var temp: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(time)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Image(systemName: icon)
                .foregroundStyle(.white, .yellow)
                .font(.system(size: 18))
                .frame(maxHeight: 20)
            
            Text("\(temp)º")
                .font(.subheadline)
        }
        .fontWeight(.semibold)
    }
}

struct HourlyWeatherWidgetView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                LargeLocationWeatherHeader(
                    location: "Минск",
                    icon: "cloud.sun.fill",
                    weather: "Временами облачно",
                    currentTemp: 19,
                    tempMin: 12,
                    tempMax: 24
                )

                Spacer()
                
                HStack(spacing: 0) {
                    HourlyWeatherItem(time: "20", icon: "cloud.sun.fill", temp: 19)
                    Spacer()
                    HourlyWeatherItem(time: "20:15", icon: "sunset.fill", temp: 19)
                    Spacer()
                    HourlyWeatherItem(time: "21", icon: "cloud.fill", temp: 19)
                    Spacer()
                    HourlyWeatherItem(time: "22", icon: "cloud.fill", temp: 19)
                    Spacer()
                    HourlyWeatherItem(time: "23", icon: "cloud.fill", temp: 19)
                    Spacer()
                    HourlyWeatherItem(time: "00", icon: "cloud.moon.fill", temp: 19)
                }

            }
            .foregroundStyle(.white)
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(Color(.blue).gradient)
        }
    }
}

struct WeatherSmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
