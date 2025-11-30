//
//  CurrentWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import Intents
import SwiftUI
import WidgetKit

struct CurrentWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func placeholder(in _: Context) -> CurrentWeatherEntry {
        let now = Date()
        
        return CurrentWeatherEntry(
            date: now,
            dt: Int(now.timeIntervalSince1970),
            sunrise: 0,
            sunset: 0,
            temperature: 0,
            icon: "",
            location: "Нет данных",
            minTemp: 0,
            maxTemp: 0,
            description: "Данные недоступны",
            isCurrentLocation: false
        )
    }

    func snapshot(for _: Intent, in context: Context) async -> CurrentWeatherEntry {
        let dt = 1_745_940_771
        
        return CurrentWeatherEntry(
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
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<CurrentWeatherEntry> {
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

            let entry = CurrentWeatherEntry(
                date: currentDate,
                dt: Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone,
                sunrise: (dailyWeather.list.first?.sunrise ?? 0) + dailyWeather.city.timezone,
                sunset: (dailyWeather.list.first?.sunset ?? 0) + dailyWeather.city.timezone,
                temperature: Int(currentWeather.main.temp.rounded()),
                icon: currentWeather.weather.first?.icon ?? "",
                location: location,
                minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                description: currentWeather.weather.first?.description ?? "Нет данных",
                isCurrentLocation: isCurrentLocation
            )

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
