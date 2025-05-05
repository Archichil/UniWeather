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

struct DailyWeatherSmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let dt = 1745940771
        DailyWeatherSmallWidgetView(entry:
            DailyWeatherSmallEntry(
                date: Date(),
                dt: dt,
                sunrise: dt - 3600 * 4,
                sunset: dt + 3600 * 5,
                temp: 19,
                icon: "02d",
                location: "Локация",
                minTemp: 12,
                maxTemp: 24,
                items: [
                    DailyWeatherItem(dt: dt + 1 * 86400, icon: "01d", minTemp: 11, maxTemp: 24),
                    DailyWeatherItem(dt: dt + 2 * 86400, icon: "02d", minTemp: 11, maxTemp: 22),
                    DailyWeatherItem(dt: dt + 3 * 86400, icon: "02d", minTemp: 11, maxTemp: 19),
                    DailyWeatherItem(dt: dt + 4 * 86400, icon: "01d", minTemp: 6, maxTemp: 24),
            ],
            isCurrentLocation: true
            )
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
