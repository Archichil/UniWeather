//
//  HourlyWeatherProvider.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import Intents
import SwiftUI
import WidgetKit

struct HourlyWeatherProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func placeholder(in _: Context) -> HourlyWeatherEntry {
        let now = Date()

        return HourlyWeatherEntry(
            date: now,
            dt: Int(now.timeIntervalSince1970),
            location: "Нет данных",
            icon: "",
            description: "Данные недоступны",
            temp: 0,
            minTemp: 0,
            maxTemp: 0,
            sunrise: 0,
            sunset: 0,
            items: [],
            isCurrentLocation: false
        )
    }

    func snapshot(for _: Intent, in _: Context) async -> HourlyWeatherEntry {
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

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<HourlyWeatherEntry> {
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

            async let hourlyWeatherTask = weatherRepository.getHourlyWeather(
                coords: coords,
                units: .metric,
                cnt: 6,
                lang: .ru
            )

            let currentWeather = try await currentWeatherTask
            let dailyWeather = try await dailyWeatherTask
            let hourlyWeather = try await hourlyWeatherTask

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

            let entry = HourlyWeatherEntry(
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

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
