//
//  WindSectionView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI
import WeatherService

struct WindSectionView: View {
    let currentWeather: CurrentWeather
    
    private enum Constants {
        enum Texts {
            static let sectionName = "ВЕТЕР"
            static let wind = "Ветер"
            static let gust = "Порывы ветра"
            static let direction = "Направление" 
            static let sunrise = "Восход"
            static let sunset = "Закат"
            static let speedUnits = "м/с"
        }
        enum Icons {
            static let sectionIcon = "wind"
        }
        
        enum Compass {
            static let north = "С"
            static let northEast = "СВ"
            static let east = "В"
            static let southEast = "ЮВ"
            static let south = "Ю"
            static let southWest = "ЮЗ"
            static let west = "З"
            static let northWest = "СЗ"
            
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
                        WindSectionView(currentWeather: weatherData)
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
