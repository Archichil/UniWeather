//
//  DetailWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit
import WeatherService
import Intents


struct DetailWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = WeatherAPIService()
    
    func placeholder(in context: Context) -> DetailWeatherEntry {
        DetailWeatherEntry(
            date: Date(),
            location: "Минск",
            icon: "02d",
            temp: 19,
            minTemp: 12,
            maxTemp: 24,
            rain: 30,
            wind: 12,
            isCurrentLocation: true
        )
    }
    
    func snapshot(for configuration: Intent, in context: Context) async -> DetailWeatherEntry {
        placeholder(in: context)
    }
    
    func timeline(for configuration: Intent, in context: Context) async -> Timeline<DetailWeatherEntry> {
        let currentDate = Date()
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        var coords: Coordinates = Coordinates(lon: 0, lat: 0)
        var isCurrentLocation = false
        
        if let geo = configuration.geo {
            
            if geo.isCurrentLocation == true {
                let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
                
                if let lat = sharedDefaults.value(forKey: "lastLatitude") as? Double,
                   let lon = sharedDefaults.value(forKey: "lastLongitude") as? Double {
                    coords = Coordinates(lon: lon, lat: lat)
                    isCurrentLocation = true
                }
            }
            else {
                coords = Coordinates(lon: geo.coordinates.lon, lat: geo.coordinates.lat)
            }
        }
    
        do {
            let currentWeather = try await weatherService.getCurrentWeather(coords: coords, units: .metric, lang: Language.ru)
            let dailyWeather = try await weatherService.getDailyWeather(coords: coords, units: .metric, count: 1)
            
            let entry: DetailWeatherEntry
            if let currentWeather = currentWeather,
               let dailyWeather = dailyWeather {
                entry = DetailWeatherEntry(
                    date: currentDate,
                    location: currentWeather.name,
                    icon: currentWeather.weather.first?.icon ?? "",
                    temp: Int(currentWeather.main.temp.rounded()),
                    minTemp: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                    maxTemp: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                    rain: Int((dailyWeather.list.first?.rain ?? 0).rounded()),
                    wind: Int((dailyWeather.list.first?.speed ?? 0).rounded()),
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

