//
//  HourlyWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

struct HourlyWeatherItemView: View {
    let entry: HourlyWeatherHourItem
    
    var body: some View {
        VStack(spacing: 4) {
            let hour = (entry.dt % 86400) / 3600
            let min = (entry.dt % 3600) / 60
            let timeString = entry.isSunsetOrSunrise ? String(format: "%d:%02d", hour, min) : String(format: "%02d", hour)
            Text(timeString)
                .font(.system(size: 11))
                .foregroundStyle(secondaryColor)
                .fontWeight(.heavy)
                .frame(alignment: .center)
            
            WeatherIcon(weatherCode: entry.icon)
                .font(.system(size: 18))
                .frame(maxHeight: 20)
                .frame(alignment: .center)
            
            Text("\(entry.temp)º")
                .font(.system(size: 13))
                .padding(.leading, 4)
        }
        .fontWeight(.semibold)
    }
}

struct HourlyWeatherWidgetView: View {
    let entry: HourlyWeatherEntry
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                LargeLocationWeatherHeader(
                    location: entry.location,
                    icon: entry.icon,
                    weather: entry.description,
                    currentTemp: entry.temp,
                    tempMin: entry.minTemp,
                    tempMax: entry.maxTemp,
                    isCurrentLocation: entry.isCurrentLocation
                )
                
                Spacer()
                
                HStack(spacing: 0) {
                    let items = itemsWithSunEvents(
                        items: entry.items,
                        count: entry.items.count,
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


struct WeatherSmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        let sunrise = 1745935200
        let sunset = 1745935200 + 3600 * 12

        let times = [
            sunrise - 3600 - 1,
            sunrise - 1,
            sunrise + 1,
            sunrise + 3600 + 1,
            sunrise + 3600 * 3 + 1,
            sunrise + 3600 * 5 + 1,
            sunset - 3600 * 3 + 1,
            sunset - 3600 * 1 + 1,
            sunset + 1,
            sunset + 3600 + 1
        ]

        
        Group {
            ForEach(times, id: \.self) { time in
                HourlyWeatherWidgetView(entry:
                    HourlyWeatherEntry(
                        date: Date(),
                        dt: time,
                        location: "Минск",
                        icon: "50d",
                        description: "Облачно с прояснениями",
                        temp: 19,
                        minTemp: 12,
                        maxTemp: 24,
                        sunrise: sunrise,
                        sunset: sunset,
                        items: [
                            HourlyWeatherHourItem(dt: 1745935200, icon: "01d", temp: 10),
                            HourlyWeatherHourItem(dt: 1745938800, icon: "02d", temp: 12),
                            HourlyWeatherHourItem(dt: 1745942400, icon: "02d", temp: 14),
                            HourlyWeatherHourItem(dt: 1745946000, icon: "03d", temp: 16),
                            HourlyWeatherHourItem(dt: 1745949600, icon: "03d", temp: 18),
                            HourlyWeatherHourItem(dt: 1745953200, icon: "04d", temp: 20)
                        ],
                        isCurrentLocation: true
                    )
                )
                .previewDisplayName("dt = \(time)")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            }
        }
    }
}
