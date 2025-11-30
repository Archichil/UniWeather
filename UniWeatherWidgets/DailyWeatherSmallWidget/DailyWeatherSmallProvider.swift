//
//  DailyWeatherSmallProvider.swift
//  UniWeather
//
//  Created by Daniil on 30.04.25.
//

import Intents
import SwiftUI
import WidgetKit

struct DailyWeatherSmallProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func placeholder(in _: Context) -> DailyWeatherSmallEntry {
        let now = Date()
        
        return DailyWeatherSmallEntry(
            date: now,
            dt: Int(now.timeIntervalSince1970),
            sunrise: 0,
            sunset: 0,
            temp: 0,
            icon: "",
            location: "Нет данных",
            minTemp: 0,
            maxTemp: 0,
            items: [],
            isCurrentLocation: false
        )
    }

    func snapshot(for _: Intent, in context: Context) async -> DailyWeatherSmallEntry {
        let dt = 1_745_940_771
        return DailyWeatherSmallEntry(
            date: Date(),
            dt: dt,
            sunrise: dt - 3600 * 4,
            sunset: dt + 3600 * 5,
            temp: 19,
            icon: "02d",
            location: "Локация",
            minTemp: 12,
            maxTemp: 24,
            items: [
                DailyWeatherItem(dt: dt + 1 * 86400, icon: "01d", minTemp: 11, maxTemp: 24),
                DailyWeatherItem(dt: dt + 2 * 86400, icon: "02d", minTemp: 11, maxTemp: 22),
                DailyWeatherItem(dt: dt + 3 * 86400, icon: "02d", minTemp: 11, maxTemp: 19),
                DailyWeatherItem(dt: dt + 4 * 86400, icon: "01d", minTemp: 6, maxTemp: 24),
            ],
            isCurrentLocation: true
        )
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<DailyWeatherSmallEntry> {
        let currentDate = Date()

        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate) ?? currentDate.addingTimeInterval(15 * 60)

        let (coords, isCurrentLocation, location) = await resolveCoordinates(from: configuration)

        do {
            async let currentWeatherTask = weatherRepository.getCurrentWeather(
                coords: coords,
                units: .metric,
                lang: .ru
            )
            
            async let dailyWeatherTask = weatherRepository.getDailyWeather(
                coords: coords,
                units: .metric,
                cnt: 5,
                lang: .ru
            )
            
            let currentWeather = try await currentWeatherTask
            let dailyWeather = try await dailyWeatherTask

            var dailyWeatherItems: [DailyWeatherItem] = []

            for item in dailyWeather.list.dropFirst() {
                dailyWeatherItems.append(
                    DailyWeatherItem(
                        dt: item.dt + dailyWeather.city.timezone,
                        icon: item.weather.first?.icon ?? "",
                        minTemp: Int(item.temp.min.rounded()),
                        maxTemp: Int(item.temp.max.rounded())
                    )
                )
            }

            let entry = DailyWeatherSmallEntry(
                date: currentDate,
                dt: Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone,
                sunrise: (dailyWeather.list.first?.sunrise ?? 0) + dailyWeather.city.timezone,
                sunset: (dailyWeather.list.first?.sunset ?? 0) + dailyWeather.city.timezone,
                temp: Int(currentWeather.main.temp.rounded()),
                icon: currentWeather.weather.first?.icon ?? "",
                location: location,
                minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                items: dailyWeatherItems,
                isCurrentLocation: isCurrentLocation
            )

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
