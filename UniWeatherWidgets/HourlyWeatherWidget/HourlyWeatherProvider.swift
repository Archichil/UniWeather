//
//  HourlyWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit
import WeatherService
import Intents

struct HourlyWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = WeatherAPIService()
    
    func placeholder(in context: Context) -> HourlyWeatherEntry {
        HourlyWeatherEntry(
            date: Date(),
            dt: 1745953200 - 1801,
            location: "Минск",
            icon: "02d",
            description: "Облачно с прояснениями",
            temp: 19,
            minTemp: 12,
            maxTemp: 24,
            sunrise: 1745953200 - 1800,
            sunset: 1745953200 + 3600,
            items: [
                HourlyWeatherHourItem(dt: 1745935200, icon: "01d", temp: 10),
                HourlyWeatherHourItem(dt: 1745938800, icon: "02d", temp: 12),
                HourlyWeatherHourItem(dt: 1745942400, icon: "02d", temp: 14),
                HourlyWeatherHourItem(dt: 1745946000, icon: "03d", temp: 16),
                HourlyWeatherHourItem(dt: 1745949600, icon: "03d", temp: 18),
                HourlyWeatherHourItem(dt: 1745953200, icon: "04d", temp: 20)
            ],
            isCurrentLocation: true
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> HourlyWeatherEntry {
        placeholder(in: context)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<HourlyWeatherEntry> {
        let currentDate = Date()
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let (coords, isCurrentLocation, location) = await resolveCoordinates(from: configuration)
    
        do {
            let currentWeather = try await weatherService.getCurrentWeather(coords: coords, units: .metric, lang: Language.ru)
            let dailyWeather = try await weatherService.getDailyWeather(coords: coords, units: .metric, count: 1)
            let hourlyWeather = try await weatherService.getHourlyWeather(coords: coords, units: .metric, count: 6)
            
            let entry: HourlyWeatherEntry
            if let currentWeather = currentWeather,
               let dailyWeather = dailyWeather,
               let hourlyWeather = hourlyWeather {
                var hourlyWeatherItems: [HourlyWeatherHourItem] = []
                
                for item in hourlyWeather.list {
                    hourlyWeatherItems.append(
                        HourlyWeatherHourItem(
                            dt: item.dt + hourlyWeather.city.timezone,
                            icon: item.weather.first?.icon ?? "",
                            temp: Int(item.main.temp.rounded())
                        )
                    )
                }
                
                entry = HourlyWeatherEntry(
                    date: currentDate,
                    dt: Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone,
                    location: location,
                    icon: currentWeather.weather.first?.icon ?? "",
                    description: currentWeather.weather.first?.description ?? "Нет данных",
                    temp: Int(currentWeather.main.temp.rounded()),
                    minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                    maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                    sunrise: (dailyWeather.list.first?.sunrise ?? 0) + dailyWeather.city.timezone,
                    sunset: (dailyWeather.list.first?.sunset ?? 0) + dailyWeather.city.timezone,
                    items: hourlyWeatherItems,
                    isCurrentLocation: isCurrentLocation
                )
                print(Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone)
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
