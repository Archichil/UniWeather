//
//  WindSectionView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import APIClient
import SwiftUI
import WeatherService

struct WindSectionView: View {
    let currentWeather: CurrentWeather

    private enum Constants {
        enum Texts {
            static let sectionName = String(localized: "windSection.sectionName")
            static let wind = String(localized: "windSection.wind")
            static let gust = String(localized: "windSection.gust")
            static let direction = String(localized: "windSection.direction")
            static let sunrise = String(localized: "windSection.sunrise")
            static let sunset = String(localized: "windSection.sunset")
            static let speedUnits = String(localized: "windSection.speedUnits")
        }

        enum Icons {
            static let sectionIcon = "wind"
        }

        enum Compass {
            static let north = String(localized: "windSection.compass.north")
            static let northEast = String(localized: "windSection.compass.northEast")
            static let east = String(localized: "windSection.compass.east")
            static let southEast = String(localized: "windSection.compass.southEast")
            static let south = String(localized: "windSection.compass.south")
            static let southWest = String(localized: "windSection.compass.southWest")
            static let west = String(localized: "windSection.compass.west")
            static let northWest = String(localized: "windSection.compass.northWest")

            static func direction(for degrees: Int) -> String {
                let directions = [north, northEast, east, southEast, south, southWest, west, northWest]
                let index = Int((Double(degrees) + 22.5) / 45.0) % 8
                return directions[index]
            }
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
            HStack(spacing: 4) {
                VStack {
                    HStack {
                        Text(Constants.Texts.wind)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(Int(currentWeather.wind.speed)) \(Constants.Texts.speedUnits)")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    Divider()
                    HStack {
                        Text(Constants.Texts.gust)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(Int(currentWeather.wind.gust ?? currentWeather.wind.speed)) \(Constants.Texts.speedUnits)")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    Divider()
                    HStack {
                        Text(Constants.Texts.direction)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(currentWeather.wind.deg)º \(Constants.Compass.direction(for: currentWeather.wind.deg))")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                CompassWindView(direction: Double(currentWeather.wind.deg), speed: currentWeather.wind.speed, unit: Constants.Texts.speedUnits)
                    .frame(width: 120, height: 120)
                    .padding(.horizontal)
            }
        }
    }
}

private struct PreviewWrapper: View {
    @State var isLoaded = false
    @State var weatherData: CurrentWeather?
    let apiService = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)
    let coordinates: Coordinates

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Rectangle()
                    .frame(width: 0, height: 300)
                if isLoaded {
                    if let weatherData {
                        WindSectionView(currentWeather: weatherData)
                    }
                }
                Rectangle()
                    .frame(width: 0, height: 300)
            }
            .padding()
            .task {
                weatherData = try? await apiService
                    .sendRequest(
                        WeatherAPISpec
                            .getCurrentWeather(
                                coords: coordinates,
                                units: .metric,
                                lang: .ru
                            )
                    )
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
