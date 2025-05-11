//
//  HolidaysForecastViewModel.swift
//  UniWeather
//
//  Created by Daniil on 1.05.25.
//

import SwiftUI
import WeatherService

class HolidaysForecastViewModel: ObservableObject {
    private let weatherService = WeatherAPIService()
    private var weather: DailyWeather? = nil
    
    @Published var eventsWithWeather: [HolidayWeather] = [
//        HolidayWeather(
//            title: "Event title 1 Event title 1 Event title 1 Event title 1",
//            notes: "Какая-то заметка Какая-то заметка Какая-то заметка",
//            date: Date.now,
//            temp: 26,
//            weather: "Солнечно",
//            icon: "01d"
//        ),
//        HolidayWeather(
//            title: "Event title 2 Event title 1 Event title 1 Event title 1",
//            notes: nil,
//            date: Date.now,
//            temp: 18,
//            weather: "Переменная облачность",
//            icon: "02d"
//        ),
//        HolidayWeather(
//            title: "Event title 3",
//            notes: nil,
//            date: Date.now,
//            temp: 15,
//            weather: "Облачно",
//            icon: "03d"
//        ),
//        HolidayWeather(
//            title: "Event title 4",
//            notes: nil,
//            date: Date.now,
//            temp: 22,
//            weather: "Облачно",
//            icon: "04d"
//        ),
//        HolidayWeather(
//            title: "Event title 5",
//            notes: nil,
//            date: Date.now,
//            temp: 14,
//            weather: "Дождь",
//            icon: "09d"
//        ),
//        HolidayWeather(
//            title: "Event title 6",
//            notes: nil,
//            date: Date.now,
//            temp: -21,
//            weather: "Снег",
//            icon: "13d"
//        ),
//        HolidayWeather(
//            title: "Event title 7",
//            notes: nil,
//            date: Date.now,
//            temp: 6,
//            weather: "Туман",
//            icon: "50d"
//        ),
    ]
    
    init() {
        Task {
            weather = try? await weatherService.getDailyWeather(
                coords: Coordinates(lat: 53.896, lon: 27.550),
                units: .metric ,
                count: 15,
                lang: .ru
            )
            await fetchEventsWithWeather()
        }
    }
    
    @MainActor
    func fetchEventsWithWeather() async {
        let events: [Holiday] = await withCheckedContinuation { continuation in
            CalendarManager.shared.getHolidays(daysAhead: 15) { result in
                continuation.resume(returning: result)
            }
        }
    
        eventsWithWeather = []
        if let weather {
            for event in events {
                let dayIndex = dayOffset(from: event.date)
                let weatherInfo = weather.list[dayIndex]
                eventsWithWeather.append(
                    HolidayWeather(
                        title: event.title,
                        notes: event.notes,
                        date: event.date,
                        temp: Int(weatherInfo.temp.day.rounded()),
                        weather: weatherInfo.weather.first?.description ?? "Нет данных",
                        icon: weatherInfo.weather.first?.icon ?? "Нет данных"
                    )
                )
            }
        }
        print(events)
    }
    
    private func dayOffset(from date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}
