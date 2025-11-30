//
//  DetailWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import Intents
import SwiftUI
import WidgetKit

struct DetailWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func placeholder(in _: Context) -> DetailWeatherEntry {
        let now = Date()
        
        return DetailWeatherEntry(
            date: now,
            dt: Int(now.timeIntervalSince1970),
            sunrise: 0,
            sunset: 0,
            location: "Нет данных",
            icon: "",
            temp: 0,
            minTemp: 0,
            maxTemp: 0,
            rain: 0,
            wind: 0,
            isCurrentLocation: false
        )
    }

    func snapshot(for _: Intent, in context: Context) async -> DetailWeatherEntry {
        let dt = 1_745_940_771
        return DetailWeatherEntry(
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
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<DetailWeatherEntry> {
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
                cnt: 1,
                lang: .ru
            )
            
            let currentWeather = try await currentWeatherTask
            let dailyWeather = try await dailyWeatherTask

            let entry = DetailWeatherEntry(
                date: currentDate,
                dt: Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone,
                sunrise: (dailyWeather.list.first?.sunrise ?? 0) + dailyWeather.city.timezone,
                sunset: (dailyWeather.list.first?.sunset ?? 0) + dailyWeather.city.timezone,
                location: location,
                icon: currentWeather.weather.first?.icon ?? "",
                temp: Int(currentWeather.main.temp.rounded()),
                minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                rain: Int((dailyWeather.list.first?.rain ?? 0).rounded()),
                wind: Int((dailyWeather.list.first?.speed ?? 0).rounded()),
                isCurrentLocation: isCurrentLocation
            )

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
