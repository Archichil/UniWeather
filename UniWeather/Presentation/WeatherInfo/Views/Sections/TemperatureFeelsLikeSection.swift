//
//  TemperatureFeelsLikeSection.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI
import WeatherService

struct TemperatureFeelsLikeSection: View {
    let currentWeather: CurrentWeather
    
    private enum Constants {
        enum Texts {
            static let sectionName = String(localized: "temperatureFeelsLikeSection.sectionName")
            static let dewPoint = String(localized: "temperatureFeelsLikeSection.dewPoint")
            static let actually = String(localized: "temperatureFeelsLikeSection.actually")
        }
        enum Icons {
            static let sectionIcon = "thermometer.medium"
        }
    }
    
    var body: some View {
        CustomStackView {
            Label {
                Text(Constants.Texts.sectionName)
            } icon: {
                Image(systemName: Constants.Icons.sectionIcon)
            }

        } contentView: {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(Int(currentWeather.main.feelsLike.rounded()))º")
                    .font(.largeTitle)
                Text("\(Constants.Texts.actually): \(Int(currentWeather.main.temp.rounded()))º")
                    .font(.subheadline)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
}

fileprivate struct PreviewWrapper: View {
    @State var isLoaded = false
    @State var weatherData: CurrentWeather?
    let apiService = WeatherAPIService()
    let coordinates: Coordinates
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Rectangle()
                    .frame(width: 0, height: 300)
                if isLoaded {
                    if let weatherData {
                        HStack {
                            TemperatureFeelsLikeSection(currentWeather: weatherData)
                            TemperatureFeelsLikeSection(currentWeather: weatherData)
                        }
                    }
                }
                Rectangle()
                    .frame(width: 0, height: 300)
            }
            .padding()
            .task {
                // FIXME: Concurrency issues, can not be fixed at this moment
                weatherData = try? await apiService.getCurrentWeather(coords: coordinates, units: .metric)
                isLoaded = true
            }
        }
    }
}

#Preview("Honolulu GMT-10") {
    PreviewWrapper(coordinates: Coordinates(lat: 21.315603, lon: -157.858093))
}

#Preview("Minsk GMT+3") {
    PreviewWrapper(coordinates: Coordinates(lat: 53.893009, lon: 27.567444))
}

#Preview("Petropavlovsk-Kamchatskiy GMT+12") {
    PreviewWrapper(coordinates: Coordinates(lat: 53.04, lon: 158.65))
}
