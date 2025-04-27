//
//  CurrentWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit
import WeatherService

struct CurrentWeatherProvider: TimelineProvider {
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
    
    func getSnapshot(in context: Context, completion: @escaping (CurrentWeatherEntry) -> Void) {
        let entry = placeholder(in: context)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CurrentWeatherEntry>) -> Void) {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let nextHourDate = calendar.nextDate(
            after: currentDate,
            matching: DateComponents(minute: 0, second: 0),
            matchingPolicy: .nextTime
        )!
        
        let coords = Coordinates(lat: 53.9, lon: 27.5667)

        Task {
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
                
                let timeline = Timeline(entries: [entry], policy: .after(nextHourDate))
                completion(timeline)
                
            } catch {
                let entry = placeholder(in: context)
                let timeline = Timeline(entries: [entry], policy: .after(nextHourDate))
                completion(timeline)
            }
        }
    }
}
