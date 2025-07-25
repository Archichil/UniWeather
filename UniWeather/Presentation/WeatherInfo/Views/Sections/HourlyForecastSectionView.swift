//
//  HourlyForecastSectionView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import APIClient
import SwiftUI
import WeatherService

struct HourlyForecastSectionView: View {
    let hourlyWeather: HourlyWeather
    let sunrise: Int?
    let sunset: Int?

    private enum Constants {
        enum Texts {
            static let sectionName = String(localized: "hourlyForecastSection.sectionName")
            static let now = String(localized: "hourlyForecastSection.now")
            static let sunrise = String(localized: "hourlyForecastSection.sunrise")
            static let sunset = String(localized: "hourlyForecastSection.sunset")
            static let localeIdentifier = "ru_RU"
        }

        enum Icons {
            static let sectionIcon = "clock"
        }

        enum TimeFormats {
            static let sunset = "HH:mm"
            static let sunrise = "HH:mm"
            static let regular = "HH"
        }
    }

    private struct HourlyWeatherItemsWrapper: Identifiable {
        var id: String = UUID().uuidString
        let temperature: String
        let icon: String
        let time: String
    }

    private var combinedItems: [HourlyWeatherItemsWrapper] {
        var items = [HourlyWeatherItemsWrapper]()
        guard !hourlyWeather.list.isEmpty else { return items }

        let nowItem = hourlyWeather.list[0]
        items.append(HourlyWeatherItemsWrapper(temperature: "\(String(Int(nowItem.main.temp)))º", icon: nowItem.weather.first?.icon ?? "", time: Constants.Texts.now))
        appendSunEvents(for: nowItem.dt, to: &items)

        for item in hourlyWeather.list {
            items.append(HourlyWeatherItemsWrapper(temperature: "\(String(Int(item.main.temp)))º", icon: item.weather.first?.icon ?? "", time: formatTime(item.dt, format: Constants.TimeFormats.regular)))
            appendSunEvents(for: item.dt, to: &items)
        }

        return items
    }

    var body: some View {
        CustomStackView {
            Label {
                Text(Constants.Texts.sectionName)
            } icon: {
                Image(systemName: Constants.Icons.sectionIcon)
            }
        } contentView: {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 16, height: 0)
                    HStack(spacing: 30) {
                        ForEach(combinedItems) { item in
                            ForecastView(time: item.time, icon: item.icon, temperature: item.temperature)
                        }
                    }
                    Rectangle()
                        .frame(width: 16, height: 0)
                }
            }
        }
    }

    // MARK: - Helpers

    private func appendSunEvents(for timestamp: Int, to items: inout [HourlyWeatherItemsWrapper]) {
        let nextHour = timestamp + 3600

        if let sunrise, (timestamp ..< nextHour).contains(sunrise) {
            items.append(HourlyWeatherItemsWrapper(temperature: Constants.Texts.sunrise, icon: "sunrise", time: formatTime(sunrise, format: Constants.TimeFormats.sunrise)))
        }

        if let sunset, (timestamp ..< nextHour).contains(sunset) {
            items.append(HourlyWeatherItemsWrapper(temperature: Constants.Texts.sunset, icon: "sunset", time: formatTime(sunset, format: Constants.TimeFormats.sunset)))
        }
    }

    private func formatTime(_ timestamp: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Constants.Texts.localeIdentifier)
        formatter.timeZone = TimeZone(secondsFromGMT: hourlyWeather.city.timezone)

        return formatter.string(from: date)
    }
}

private struct PreviewWrapper: View {
    @State var isLoaded = false
    @State var weatherData: HourlyWeather?
    let apiService = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)
    let coordinates: Coordinates

    var body: some View {
        VStack {
            if isLoaded {
                HourlyForecastSectionView(hourlyWeather: weatherData!, sunrise: weatherData?.city.sunrise, sunset: weatherData?.city.sunset)
            }
        }
        .padding()
        .task {
            weatherData = try? await apiService
                .sendRequest(
                    WeatherAPISpec
                        .getHourlyWeather(
                            coords: coordinates,
                            units: .metric,
                            cnt: 25,
                            lang: .ru
                        )
                )
            isLoaded = true
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
