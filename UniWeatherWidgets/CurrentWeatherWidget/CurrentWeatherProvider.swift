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
            temperature: 19,
            icon: "02d",
            location: "Минск",
            minTemp: 12,
            maxTemp: 24,
            description: "Переменная облачность"
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> CurrentWeatherEntry {
        placeholder(in: context)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<CurrentWeatherEntry> {
        let currentDate = Date()
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        var coords: Coordinates
//        if let geo = configuration.geo {
//            coords = geo.coordinates
//        } else {

//        }
        
        coords = Coordinates(lon: 12, lat: 12)
    
        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
        
        if let lat = sharedDefaults.value(forKey: "lastLatitude") as? Double,
           let lon = sharedDefaults.value(forKey: "lastLongitude") as? Double {
            coords = Coordinates(lon: lon, lat: lat)
            print(coords)
        }
        
        do {
            let currentWeather = try await weatherService.getCurrentWeather(coords: coords, units: .metric, lang: Language.ru)
            let dailyWeather = try await weatherService.getDailyWeather(coords: coords, units: .metric, count: 15)
            
            let entry: CurrentWeatherEntry
            if let currentWeather = currentWeather,
               let dailyWeather = dailyWeather {
                entry = CurrentWeatherEntry(
                    date: currentDate,
                    temperature: Int(currentWeather.main.temp.rounded()),
                    icon: currentWeather.weather.first?.icon ?? "",
                    location: currentWeather.name,
                    minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                    maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                    description: currentWeather.weather.first?.description ?? "нет данных"
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
