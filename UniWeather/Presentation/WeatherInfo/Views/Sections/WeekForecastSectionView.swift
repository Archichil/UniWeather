//
//  WeekForecastSectionView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI
import WeatherService

struct WeekForecastSectionView: View {
    private struct DailyWeatherItemsWrapper: Identifiable {
        var id: String = UUID().uuidString
        let dt: Int
        let tempMin: Int
        let tempMax: Int
        let overallMin: Double
        let overallMax: Double
        let icon: String
    }
    
    let dailyWeather: DailyWeather
    
    private var temperatureExtremes: (min: Double, max: Double) {
        let extremes = dailyWeather.list.reduce((min: Double.infinity, max: -Double.infinity)) { acc, day in
            (min: min(acc.min, day.temp.min),
            max: max(acc.max, day.temp.max))
        }
        return (min: extremes.min, max: extremes.max)
    }
    
    private var wrappedDays: [DailyWeatherItemsWrapper] {
        var items = [DailyWeatherItemsWrapper]()
        guard !dailyWeather.list.isEmpty else { return items }
        
        for day in dailyWeather.list {
            items.append(DailyWeatherItemsWrapper(dt: day.dt, tempMin: Int(day.temp.min), tempMax: Int(day.temp.max), overallMin: temperatureExtremes.min, overallMax: temperatureExtremes.max, icon: day.weather.first?.icon ?? ""))
        }
        
        return items
    }
    
    private enum Constants {
        enum Texts {
            static let today = String(localized: "weekForecastSection.today")
            static let sectionName = String(localized: "weekForecastSection.sectionName")
            static let localeIdentifier = "ru_RU"
        }
        enum Icons {
            static let sectionIcon = "calendar"
        }
        enum TimeFormats {
            static let day = "E"
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
                    ForEach(wrappedDays) { day in
                        HStack(spacing: 0) {
                            HStack {
                                Text(formatTime(day.dt, format: Constants.TimeFormats.day))
                                    .font(.headline)
                                    .bold()
                                    .frame(width: 70, alignment: .leading)
                                WeatherIconView(weatherCode: day.icon)
                                    .font(.title2)
                            }
                            .frame(alignment: .leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack(spacing: 12) {
                                
                                Text("\(day.tempMin)º")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 50, alignment: .trailing)
                                TemperatureGradientBarView(overallMin: day.overallMin, overallMax: day.overallMax, dayMin: Double(day.tempMin), dayMax: Double(day.tempMax))
                                    .frame(height: 4)
                                Text("\(day.tempMax)º")
                                    .frame(width: 50, alignment: .leading)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .frame(alignment: .trailing)
                            }
                            .frame(alignment: .trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .frame(width: 220, height: 35)
                        }
                        Divider()
                            .padding(.trailing)
                    }
                }
                .padding(.leading)
            }
        }
    }
    
    private func formatTime(_ timestamp: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        var calendar = Calendar.current
        if let timezone = TimeZone(secondsFromGMT: dailyWeather.city.timezone) {
            calendar.timeZone = timezone
        }
        if calendar.isDateInToday(date) {
            return Constants.Texts.today
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.Texts.localeIdentifier)
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(secondsFromGMT: dailyWeather.city.timezone)
        
        return formatter.string(from: date)
    }
}

fileprivate struct PreviewWrapper: View {
    @State var isLoaded = false
    @State var weatherData: DailyWeather?
    let apiService = WeatherAPIService()
    let coordinates: Coordinates
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Rectangle()
                    .frame(width: 0, height: 300)
                if isLoaded {
                    WeekForecastSectionView(dailyWeather: weatherData!)
                }
                Rectangle()
                    .frame(width: 0, height: 300)
            }
            .padding()
            .task {
                // FIXME: Concurrency issues, can not be fixed at this moment
                weatherData = try? await apiService.getDailyWeather(coords: coordinates, units: .metric, count: 14)
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
