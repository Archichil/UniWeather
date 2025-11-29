//
//  DailyWeatherLargeProvider.swift
//  UniWeather
//
//  Created by Daniil on 4.05.25.
//

import Intents
import SwiftUI
import WidgetKit

struct DailyWeatherLargeProvider: AppIntentTimelineProvider {
    typealias Intent = LocationIntent

    private let weatherRepository: WeatherRepositoryProtocol

    init(weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weatherRepository = weatherRepository
    }

    func placeholder(in _: Context) -> DailyWeatherLargeEntry {
        let now = Date()
        let dt = 1_745_940_771

        return DailyWeatherLargeEntry(
            date: now,
            dt: Int(now.timeIntervalSince1970),
            sunset: 0,
            sunrise: 0,
            location: "Нет данных",
            icon: "",
            description: "Данные недоступны",
            currentTemp: 0,
            tempMin: 0,
            tempMax: 0,
            hourlyItems: [
                HourlyWeatherHourItem(
                    dt: dt + 1 * 3600,
                    icon: "",
                    temp: 0
                ),
                HourlyWeatherHourItem(
                    dt: dt + 2 * 3600,
                    icon: "",
                    temp: 0
                ),
                HourlyWeatherHourItem(
                    dt: dt + 3 * 3600,
                    icon: "",
                    temp: 0
                ),
                HourlyWeatherHourItem(
                    dt: dt + 4 * 3600,
                    icon: "",
                    temp: 0
                ),
                HourlyWeatherHourItem(
                    dt: dt + 5 * 3600,
                    icon: "",
                    temp: 0
                ),
                HourlyWeatherHourItem(
                    dt: dt + 6 * 3600,
                    icon: "",
                    temp: 0
                ),
            ],
            dailyItems: [
                WeatherDailyItem(
                    dt: dt + 1 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: ""
                ),
                WeatherDailyItem(
                    dt: dt + 2 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: ""
                ),
                WeatherDailyItem(
                    dt: dt + 3 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: ""
                ),
                WeatherDailyItem(
                    dt: dt + 4 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: ""
                ),
                WeatherDailyItem(
                    dt: dt + 5 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: ""
                ),
            ],
            isCurrentLocation: false
        )
    }

    func snapshot(for _: Intent, in _: Context) async -> DailyWeatherLargeEntry {
        let dt = 1_745_940_771
        return DailyWeatherLargeEntry(
            date: Date(),
            dt: dt,
            sunset: dt + 3600 * 5,
            sunrise: dt - 3600 * 4,
            location: "Локация",
            icon: "02d",
            description: "Переменная облачность",
            currentTemp: 12,
            tempMin: 6,
            tempMax: 24,
            hourlyItems: [
                HourlyWeatherHourItem(
                    dt: dt + 1 * 3600,
                    icon: "01d",
                    temp: 10
                ),
                HourlyWeatherHourItem(
                    dt: dt + 2 * 3600,
                    icon: "02d",
                    temp: 12
                ),
                HourlyWeatherHourItem(
                    dt: dt + 3 * 3600,
                    icon: "03d",
                    temp: 14
                ),
                HourlyWeatherHourItem(
                    dt: dt + 4 * 3600,
                    icon: "04d",
                    temp: 16
                ),
                HourlyWeatherHourItem(
                    dt: dt + 5 * 3600,
                    icon: "01d",
                    temp: 14
                ),
                HourlyWeatherHourItem(
                    dt: dt + 6 * 3600,
                    icon: "02d",
                    temp: 12
                ),
            ],
            dailyItems: [
                WeatherDailyItem(
                    dt: dt + 1 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 22,
                    icon: "01d"
                ),
                WeatherDailyItem(
                    dt: dt + 2 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 23,
                    icon: "02d"
                ),
                WeatherDailyItem(
                    dt: dt + 3 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 24,
                    icon: "03d"
                ),
                WeatherDailyItem(
                    dt: dt + 4 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 11,
                    maxTemp: 19,
                    icon: "02d"
                ),
                WeatherDailyItem(
                    dt: dt + 5 * 86400,
                    overallMinTemp: 6,
                    overallMaxTemp: 24,
                    minTemp: 6,
                    maxTemp: 16,
                    icon: "04d"
                ),
            ],
            isCurrentLocation: true
        )
    }

    func timeline(for configuration: Intent, in context: Context) async -> Timeline<DailyWeatherLargeEntry> {
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
                cnt: 6,
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

            var dailyWeatherItems: [WeatherDailyItem] = []
            let overallMinTemp = dailyWeather.list.min(by: { $0.temp.min < $1.temp.min })?.temp.min.rounded() ?? 0.0
            let overallMaxTemp = dailyWeather.list.max(by: { $0.temp.max < $1.temp.max })?.temp.max.rounded() ?? 0.0
            for item in dailyWeather.list.dropFirst() {
                dailyWeatherItems.append(WeatherDailyItem(
                    dt: item.dt + dailyWeather.city.timezone,
                    overallMinTemp: Int(overallMinTemp.rounded()),
                    overallMaxTemp: Int(overallMaxTemp.rounded()),
                    minTemp: Int(item.temp.min.rounded()),
                    maxTemp: Int(item.temp.max.rounded()),
                    icon: item.weather.first?.icon ?? ""
                )
                )
            }

            let entry = DailyWeatherLargeEntry(
                date: Date(),
                dt: Int(Date().timeIntervalSince1970) + dailyWeather.city.timezone,
                sunset: (dailyWeather.list.first?.sunset ?? 0) + dailyWeather.city.timezone,
                sunrise: (dailyWeather.list.first?.sunrise ?? 0) + dailyWeather.city.timezone,
                location: location,
                icon: currentWeather.weather.first?.icon ?? "",
                description: currentWeather.weather.first?.description ?? "Нет данных",
                currentTemp: Int(currentWeather.main.temp.rounded()),
                tempMin: Int((dailyWeather.list.first?.temp.min ?? 0).rounded()),
                tempMax: Int((dailyWeather.list.first?.temp.max ?? 0).rounded()),
                hourlyItems: hourlyWeatherItems,
                dailyItems: dailyWeatherItems,
                isCurrentLocation: isCurrentLocation
            )

            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        } catch {
            let entry = placeholder(in: context)
            return Timeline(entries: [entry], policy: .after(nextUpdateDate))
        }
    }
}
