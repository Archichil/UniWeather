//
//  DetailWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit

private struct DetailWeatherWidgetSection: View {
    let title: String
    let value: Int
    let units: String
    var icon: String?
    var zeroPlaceholder: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundStyle(.white)

            HStack(spacing: 6) {
                if icon != nil, zeroPlaceholder == nil {
                    Image(systemName: icon!)
                }

                Text(zeroPlaceholder ?? "\(value) \(units)")
            }
            .foregroundStyle(secondaryColor)
        }
        .font(.system(size: 13))
        .fontWeight(.bold)
    }
}

struct DetailWeatherWidgetView: View {
    let entry: DetailWeatherEntry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                LocationWeatherHeader(
                    location: entry.location,
                    icon: entry.icon,
                    currentTemp: entry.temp,
                    tempMin: entry.minTemp,
                    tempMax: entry.maxTemp,
                    isCurrentLocation: entry.isCurrentLocation
                )

                VStack(alignment: .leading, spacing: 1) {
                    DetailWeatherWidgetSection(
                        title: "Осадки",
                        value: entry.rain,
                        units: "%",
                        icon: "cloud.rain.fill",
                        zeroPlaceholder: entry.rain == 0 ? "Без осадков" : nil
                    )

                    DetailWeatherWidgetSection(
                        title: "Ветер",
                        value: entry.wind,
                        units: "км/ч",
                        zeroPlaceholder: entry.wind == 0 ? "Безветренно" : nil
                    )
                }
            }
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

struct DetailWeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let dt = 1_745_940_771
        DetailWeatherWidgetView(entry:
            DetailWeatherEntry(
                date: Date(),
                dt: dt,
                sunrise: dt - 3600 * 4,
                sunset: dt + 3600 * 5,
                location: "Локация",
                icon: "02d",
                temp: 19,
                minTemp: 12,
                maxTemp: 24,
                rain: 30,
                wind: 12,
                isCurrentLocation: true
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
