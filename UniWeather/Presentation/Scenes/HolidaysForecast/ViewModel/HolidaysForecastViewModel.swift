import APIClient
import SwiftUI
import WeatherService

class HolidaysForecastViewModel: ObservableObject {
    private let weahterRepository: WeatherRepositoryProtocol
    private var weather: DailyWeather?
    let coordinates: Coordinates

    @Published var eventsWithWeather: [HolidayWeather] = []

    private enum Constants {
        enum Texts {
            static let noData = String(localized: "holidaysForecast.noData")
        }
    }

    init(coordinates: Coordinates, weatherRepository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.weahterRepository = weatherRepository
        self.coordinates = coordinates
        Task {
            weather = try? await weatherRepository
                .getDailyWeather(
                    coords: coordinates,
                    units: .metric,
                    cnt: 15,
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
                        weather: weatherInfo.weather.first?.description ?? Constants.Texts.noData,
                        icon: weatherInfo.weather.first?.icon ?? Constants.Texts.noData
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
