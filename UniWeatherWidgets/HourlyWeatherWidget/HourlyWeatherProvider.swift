//
//  HourlyWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import APIClient
import Intents
import SwiftUI
import WeatherService
import WidgetKit

struct HourlyWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent
    private let weatherService = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)

    func placeholder(in _: Context) -> HourlyWeatherEntry {
        let dt = 1_745_940_771
        return HourlyWeatherEntry(
            date: Date(),
            dt: dt,
            location: "Локация",
            icon: "02d",
            description: "Переменная облачность",
            temp: 19,
            minTemp: 12,
            maxTemp: 24,
            sunrise: dt - 3600 * 4,
            sunset: dt + 3600 * 5,
            items: [
                HourlyWeatherHourItem(dt: dt + 1 * 3600, icon: "01d", temp: 10),
                HourlyWeatherHourItem(dt: dt + 2 * 3600, icon: "02d", temp: 12),
                HourlyWeatherHourItem(dt: dt + 3 * 3600, icon: "02d", temp: 14),
                HourlyWeatherHourItem(dt: dt + 4 * 3600, icon: "04d", temp: 16),
                HourlyWeatherHourItem(dt: dt + 5 * 3600, icon: "01d", temp: 14),
                HourlyWeatherHourItem(dt: dt + 6 * 3600, icon: "02d", temp: 12),
            ],
            isCurrentLocation: true
        )
    }

    func snapshot(for _: Intent, in context: Context) async -> HourlyWeatherEntry {
        placeholder(in: context)
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<HourlyWeatherEntry> {
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
            let hourlyWeather: HourlyWeather? = try await weatherService.sendRequest(
                WeatherAPISpec
                    .getHourlyWeather(
                        coords: coords,
                        units: .metric,
                        cnt: 6,
                        lang: .ru
                    )
            )

            let entry: HourlyWeatherEntry
            if let currentWeather,
               let dailyWeather,
               let hourlyWeather
            {
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
