//
//  HumiditySection.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI
import WeatherService

struct HumiditySection: View {
    let currentWeather: CurrentWeather
    
    private var dewPoint: Int {
        let temperature = currentWeather.main.temp
        let humidity = currentWeather.main.humidity
        
        // Magnus-Tetens formula
        let alpha = 17.27
        let beta = 237.7
        let temp = temperature
        let gamma = (alpha * temp) / (beta + temp) + log(Double(humidity)/100.0)
        let dewPointTemp = (beta * gamma) / (alpha - gamma)
        
        return Int(dewPointTemp.rounded())
    }
    
    private enum Constants {
        enum Texts {
            static let sectionName = "ВЛАЖНОСТЬ"
            static let dewPoint = "Точка росы сейчас"
        }
        enum Icons {
            static let sectionIcon = "drop.fill"
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
                Text("\(currentWeather.main.humidity) %")
                    .font(.largeTitle)
                    .frame(maxHeight: .infinity, alignment: .top)
                Text("\(Constants.Texts.dewPoint): \(dewPoint)º.")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
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
                        HumiditySection(currentWeather: weatherData)
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
