//
//  AirQualitySectionView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI
import WeatherService

struct AirQualitySectionView: View {
    let currentAirPollution: AirPollution
    
    private enum Constants {
        enum Texts {
            static let sectionName = String(localized: "airQualitySection.sectionName")
            static let level = String(localized: "airQualitySection.level")
            static let unknown = String(localized: "airQualitySection.unknown")
        }
        enum Icons {
            static let sectionIcon = "circle.hexagongrid.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            CustomStackView {
                Label {
                    Text(Constants.Texts.sectionName)
                } icon: {
                    Image(systemName: Constants.Icons.sectionIcon)
                }

            } contentView: {
                VStack(alignment: .leading, spacing: 8) {
                    if let aqiLevel = currentAirPollution.list.first?.main.aqi {
                        Text("\(aqiLevel) \(Constants.Texts.level)")
                            .font(.largeTitle)
                        Text("\(AirQualityBarView.getLevelDescription(aqi: aqiLevel))")
                            .font(.title2)
                        AirQualityBarView(groupIndex: aqiLevel)
                    } else {
                        Text(Constants.Texts.unknown)
                            .font(.largeTitle)
                    }
                }
                .padding(.horizontal)
            }

        }
    }
}

fileprivate struct PreviewWrapper: View {
    @State var isLoaded = false
    @State var airData: AirPollution?
    let apiService = WeatherAPIService()
    let coordinates: Coordinates
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Rectangle()
                    .frame(width: 0, height: 300)
                if isLoaded {
                    if let airData {
                        AirQualitySectionView(currentAirPollution: airData)
                    }
                }
                Rectangle()
                    .frame(width: 0, height: 300)
            }
            .padding()
            .task {
                // FIXME: Concurrency issues, can not be fixed at this moment
                airData = try? await apiService.getCurrentAirPollution(coords: coordinates)
                isLoaded = true
            }
        }
    }
}

#Preview("Delhi, India") {
    PreviewWrapper(coordinates: Coordinates(lat: 28.652, lon: 77.2315))
}

#Preview("Minsk, Belarus") {
    PreviewWrapper(coordinates: Coordinates(lat: 53.893009, lon: 27.567444))
}

#Preview("Danjiangkou, China") {
    PreviewWrapper(coordinates: Coordinates(lat: 32.559, lon: 111.488))
}
