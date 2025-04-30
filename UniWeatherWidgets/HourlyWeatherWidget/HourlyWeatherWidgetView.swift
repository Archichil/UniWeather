//
//  HourlyWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

private struct HourlyWeatherItem: View {
    let entry: HourlyWeatherHourItem
    
    var body: some View {
        VStack(spacing: 4) {
            let hour = (entry.dt % 86400) / 3600
            let min = (entry.dt % 3600) / 60
            let timeString = entry.isSunsetOrSunrise ? String(format: "%d:%02d", hour, min) : String(format: "%02d", hour)
            Text(timeString)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
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
                    let items = itemsWithSunEvents(entry: entry)
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        HourlyWeatherItem(entry: item)
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
    
    private func itemsWithSunEvents(entry: HourlyWeatherEntry) -> [HourlyWeatherHourItem] {
        var result = entry.items

        func insert(type: String, time: Int) {
            let sunEventItem = HourlyWeatherHourItem(
                dt: time,
                icon: type,
                temp: nearestTemp(for: time, in: result),
                isSunsetOrSunrise: true
            )

            if time > result.last?.dt ?? 0 {
                return
            }

            let insertIndex = result.firstIndex(where: { $0.dt > time }) ?? result.count
            
            if insertIndex == 0 {
                result.insert(sunEventItem, at: insertIndex)
            } else if insertIndex == result.count {
                result.append(sunEventItem)
            } else {
                result.insert(sunEventItem, at: insertIndex)
            }

            if result.count > entry.items.count {
                result.removeLast()
            }
        }

        func nearestTemp(for time: Int, in items: [HourlyWeatherHourItem]) -> Int {
            items.min(by: { abs($0.dt - time) < abs($1.dt - time) })?.temp ?? 0
        }

        if let first = entry.items.first?.dt, let last = entry.items.last?.dt {
            let extendedStart = first - 3600
            let extendedEnd = last + 3600

            if entry.sunrise >= extendedStart && entry.sunrise <= extendedEnd && entry.sunrise >= entry.dt {
                insert(type: "sunrise", time: entry.sunrise)
            }

            if entry.sunset >= extendedStart && entry.sunset <= extendedEnd && entry.sunset >= entry.dt {
                insert(type: "sunset", time: entry.sunset)
            }
        }

        return result.sorted(by: { $0.dt < $1.dt })
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
