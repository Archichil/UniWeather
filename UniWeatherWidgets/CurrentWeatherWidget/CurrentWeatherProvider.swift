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
            temperature: 0,
            icon: "нет данных",
            location: "нет данных",
            minTemp: 0,
            maxTemp: 0,
            description: "нет данных"
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> CurrentWeatherEntry  {
        placeholder(in: context)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<CurrentWeatherEntry> {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let nextHourDate = calendar.nextDate(
            after: currentDate,
            matching: DateComponents(minute: 0, second: 0),
            matchingPolicy: .nextTime
        )!
        
        var coords: Coordinates
        if let geo = configuration.geo {
            coords = geo.coordinates
        } else {
            coords = Coordinates(lat: 12, lon: 12)
        }
        
        do {
            let currentWeather = try await weatherService.getCurrentWeather(coords: coords, units: .metric, lang: Language.ru)
            
            // for daily min and max temps (current weather request doesn't provide daily min and max temps)
            let dailyWeather = try await weatherService.getDailyWeather(coords: coords, units: .metric, count: 1)
            
            let entry: CurrentWeatherEntry
            if let currentWeather = currentWeather,
               let dailyWeather = dailyWeather {
                entry = CurrentWeatherEntry(
                    date: currentDate,
                    temperature: Int(currentWeather.main.temp.rounded()),
                    icon: currentWeather.weather.first?.description ?? "нет данных",
                    location: currentWeather.name,
                    minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                    maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                    description: currentWeather.weather.first?.description ?? "нет данных"
                )
            } else {
                entry = placeholder(in: context)
            }
            
            return Timeline(entries: [entry], policy: .after(nextHourDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextHourDate))
        }
        
    }
}
