//
//  DailyWeatherSmallWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit

private struct DailyWeatherRow: View {
    let item: DailyWeatherItem
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(getShortWeekday(from: item.dt))
                    .frame(maxWidth: 26, alignment: .leading)
                
                WeatherIcon(weatherCode: item.icon)

            }
            .font(.system(size: 13))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Text("\(item.minTemp)")
                    .foregroundStyle(secondaryColor)
                
                Text("\(item.maxTemp)º")
                    .foregroundStyle(.white)
                    .frame(maxWidth: 26, alignment: .trailing)
            }
            .font(.system(size: 13))
        }
        .frame(maxWidth: .infinity)
        .bold()
    }
}

struct DailyWeatherSmallWidgetView: View {
    let entry: DailyWeatherSmallEntry
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LocationWeatherHeader(
                    location: entry.location,
                    icon: entry.icon,
                    currentTemp: entry.temp,
                    tempMin: entry.minTemp,
                    tempMax: entry.maxTemp,
                    isCurrentLocation: entry.isCurrentLocation
                )
                
                VStack(spacing: 2) {
                    ForEach(entry.items, id: \.dt) { item in
                        DailyWeatherRow(item: item)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.top, 2)
            }
            .foregroundStyle(.white)
        }
        .containerBackground(for: .widget) {
            let gradient = getBackgroundGradient(
                weatherCode: entry.icon,
                dt: entry.dt,
                sunset: entry.sunset,
                sunrise: entry.sunrise
            )
            ContainerRelativeShape()
                .fill(LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                ))
        }
    }
}
