//
//  CurrentWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit

struct CurrentWeatherWidgetView: View {
    var entry: CurrentWeatherEntry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                LocationTitle(location: entry.location, textSize: 15, isCurrentLocation: entry.isCurrentLocation)

                Text("\(entry.temperature)º")
                    .font(.largeTitle)
                    .fontWeight(.regular)

                VStack(alignment: .leading, spacing: 0) {
                    WeatherIcon(weatherCode: entry.icon)
                        .font(.system(size: 15))

                    Text(entry.description.prefix(1).capitalized + entry.description.dropFirst())
                        .font(.system(size: 13))
                        .bold()
                        .lineLimit(2)
                }.frame(maxHeight: .infinity, alignment: .bottom)

                HStack(spacing: 1) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 11))
                        .fontWeight(.heavy)
                    Text("\(entry.minTemp)º")

                    Image(systemName: "arrow.up")
                        .font(.system(size: 11))
                        .fontWeight(.heavy)
                    Text("\(entry.maxTemp)º")
                }
                .font(.system(size: 13))
                .padding(.top, 1)
            }
            .bold()
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

struct CurrentWeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let dt = 1_745_940_771
        CurrentWeatherWidgetView(entry:
            CurrentWeatherEntry(
                date: Date(),
                dt: dt,
                sunrise: dt - 3600 * 4,
                sunset: dt + 3600 * 5,
                temperature: 19,
                icon: "02d",
                location: "Локация",
                minTemp: 12,
                maxTemp: 24,
                description: "Переменная облачность",
                isCurrentLocation: true
            )
        ).previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
