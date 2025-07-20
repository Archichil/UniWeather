//
//  CurrentWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import Intents
import SwiftUI
import WeatherService
import WidgetKit
import APIClient

struct CurrentWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)

    func placeholder(in _: Context) -> CurrentWeatherEntry {
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

    func snapshot(for _: Intent, in context: Context) async -> CurrentWeatherEntry {
        placeholder(in: context)
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<CurrentWeatherEntry> {
        let currentDate = Date()

        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let (coords, isCurrentLocation, location) = await resolveCoordinates(from: configuration)

        do {
            let currentWeather: CurrentWeather? = try await weatherService.sendRequest(
                WeatherAPISpec.getCurrentWeather(coords: coords, units: .metric, lang: .ru)
            )
            let dailyWeather: DailyWeather? = try await weatherService.sendRequest(
                WeatherAPISpec
                    .getDailyWeather(
                        coords: coords,
                        units: .metric,
                        cnt: 1,
                        lang: .ru
                    )
            )

            let entry: CurrentWeatherEntry = if let currentWeather,
                                                let dailyWeather
            {
                CurrentWeatherEntry(
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
                placeholder(in: context)
            }

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
