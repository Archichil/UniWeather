//
//  CurrentWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit
import WeatherService
import Intents

struct CurrentWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = WeatherAPIService()
    
    func placeholder(in context: Context) -> CurrentWeatherEntry {
        CurrentWeatherEntry(
            date: Date(),
            dt: 1745953200,
            sunrise: 1745953200 - 3600 * 4,
            sunset: 1745953200 + 3600 * 8,
            temperature: 19,
            icon: "02d",
            location: "Минск",
            minTemp: 12,
            maxTemp: 24,
            description: "Переменная облачность",
            isCurrentLocation: false
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> CurrentWeatherEntry {
        placeholder(in: context)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<CurrentWeatherEntry> {
        let currentDate = Date()
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let (coords, isCurrentLocation, location) = await resolveCoordinates(from: configuration)
    
        do {
            let currentWeather = try await weatherService.getCurrentWeather(coords: coords, units: .metric, lang: Language.ru)
            let dailyWeather = try await weatherService.getDailyWeather(coords: coords, units: .metric, count: 1)
            
            let entry: CurrentWeatherEntry
            if let currentWeather = currentWeather,
               let dailyWeather = dailyWeather {
                entry = CurrentWeatherEntry(
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
            } else {
                entry = placeholder(in: context)
            }
            
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
