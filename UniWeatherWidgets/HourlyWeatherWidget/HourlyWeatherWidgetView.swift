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


struct HourlyWeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let dt = 1745940771
        HourlyWeatherWidgetView(entry:
            HourlyWeatherEntry(
                date: Date(),
                dt: dt,
                location: "Локация",
                icon: "02d",
                description: "Переменная облачность",
                temp: 19,
                minTemp: 12,
                maxTemp: 24,
                sunrise: dt - 3600 * 4,
                sunset: dt + 3600 * 5,
                items: [
                    HourlyWeatherHourItem(dt: dt + 1 * 3600, icon: "01d", temp: 10),
                    HourlyWeatherHourItem(dt: dt + 2 * 3600, icon: "02d", temp: 12),
                    HourlyWeatherHourItem(dt: dt + 3 * 3600, icon: "02d", temp: 14),
                    HourlyWeatherHourItem(dt: dt + 4 * 3600, icon: "04d", temp: 16),
                    HourlyWeatherHourItem(dt: dt + 5 * 3600, icon: "01d", temp: 14),
                    HourlyWeatherHourItem(dt: dt + 6 * 3600, icon: "02d", temp: 12)
                ],
                isCurrentLocation: true
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
