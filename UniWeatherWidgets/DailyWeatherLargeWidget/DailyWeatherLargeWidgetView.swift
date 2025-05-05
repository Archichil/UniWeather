//
//  DailyWeatherLargeWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 4.05.25.
//

import WidgetKit
import SwiftUI

private struct DayWeatherRow: View {
    let entry: WeatherDailyItem
    
    var body: some View {
        HStack(spacing: 0) {
            Text(getShortWeekday(from: entry.dt))
                .frame(maxWidth: 55, alignment: .leading)
            
            WeatherIcon(weatherCode: entry.icon)
                .font(.system(size: 16))
                

            HStack(alignment: .center, spacing: 0) {
                Text("\(entry.minTemp)º")
                    .foregroundStyle(secondaryColor)
                    .frame(maxWidth: 24, alignment: .leading)
                
                TemperatureGradientBarView(
                    overallMin: Double(entry.overallMinTemp),
                    overallMax: Double(entry.overallMaxTemp),
                    dayMin: Double(entry.minTemp),
                    dayMax: Double(entry.maxTemp)
                )
                .frame(maxWidth: 135, maxHeight: 4)
                    
                Text("\(entry.maxTemp)º")
                    .frame(maxWidth: 30, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .font(.system(size: 13))
        .fontWeight(.semibold)
    }
}

struct DailyWeatherLargeWidgetView: View {
    let entry: DailyWeatherLargeEntry
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                LargeLocationWeatherHeader(
                    location: entry.location,
                    icon: entry.icon,
                    weather: entry.description,
                    currentTemp: entry.currentTemp,
                    tempMin: entry.tempMin,
                    tempMax: entry.tempMax,
                    isCurrentLocation: entry.isCurrentLocation
                )
                
                Rectangle()
                    .frame(maxHeight: 0.5)
                    .foregroundStyle(.white.opacity(0.2))
                
                HStack(spacing: 0) {
                    let items = itemsWithSunEvents(
                        items: entry.hourlyItems,
                        count: entry.hourlyItems.count,
                        sunrise: entry.sunrise,
                        sunset: entry.sunset,
                        dt: entry.dt)
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        HourlyWeatherItemView(entry: item)
                        if index < items.count - 1 {
                            Spacer()
                        }
                    }
                }
                
                Rectangle()
                    .frame(maxHeight: 0.5)
                    .foregroundStyle(.white.opacity(0.2))
                
                VStack(spacing: 0) {
                    ForEach(entry.dailyItems.indices, id: \.self) { index in
                        DayWeatherRow(entry: entry.dailyItems[index])
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

struct DailyWeatherLargeWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let dt = 1745940771
        DailyWeatherLargeWidgetView(entry: DailyWeatherLargeEntry(
            date: Date(),
            dt: dt,
            sunset: dt + 3600 * 5,
            sunrise: dt - 3600 * 4,
            location: "Локакция",
            icon: "02d",
            description: "Переменная облачность",
            currentTemp: 12,
            tempMin: 6,
            tempMax: 24,
            hourlyItems: [
                HourlyWeatherHourItem(
                    dt: dt + 1 * 3600,
                    icon: "01d",
                    temp: 10),
                HourlyWeatherHourItem(
                    dt: dt + 2 * 3600,
                    icon: "02d",
                    temp: 12),
                HourlyWeatherHourItem(
                    dt: dt + 3 * 3600,
                    icon: "03d",
                    temp: 14),
                HourlyWeatherHourItem(
                    dt: dt + 4 * 3600,
                    icon: "04d",
                    temp: 16),
                HourlyWeatherHourItem(
                    dt: dt + 5 * 3600,
                    icon: "01d",
                    temp: 14),
                HourlyWeatherHourItem(
                    dt: dt + 6 * 3600,
                    icon: "02d",
                    temp: 12),
            ],
            dailyItems: [
                WeatherDailyItem(
                    dt: dt + 1 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: "01d"),
                WeatherDailyItem(
                    dt: dt + 2 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 23,
                    icon: "02d"),
                WeatherDailyItem(
                    dt: dt + 3 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 24,
                    icon: "03d"),
                WeatherDailyItem(
                    dt: dt + 4 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 19,
                    icon: "02d"),
                WeatherDailyItem(
                    dt: dt + 5 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 6,
                    maxTemp: 5,
                    icon: "04d"),
            ],
            isCurrentLocation: true
        ))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

