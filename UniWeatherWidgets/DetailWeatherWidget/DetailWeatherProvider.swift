//
//  DetailWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import APIClient
import Intents
import SwiftUI
import WeatherService
import WidgetKit

struct DetailWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)

    func placeholder(in _: Context) -> DetailWeatherEntry {
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

    func snapshot(for _: Intent, in context: Context) async -> DetailWeatherEntry {
        placeholder(in: context)
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<DetailWeatherEntry> {
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

            let entry: DetailWeatherEntry = if let currentWeather,
                                               let dailyWeather
            {
                DetailWeatherEntry(
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
