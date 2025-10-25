import APIClient
import Foundation
import WeatherService

final class WeatherRepository: WeatherRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient(baseURL: URL(string: WeatherAPISpec.baseURL)!)) {
        self.apiClient = apiClient
    }

    func getCurrentWeather(coords: Coordinates, units: Units?, lang: Language?) async throws -> CurrentWeather {
        try await apiClient.sendRequest(
            WeatherAPISpec.getCurrentWeather(coords: coords, units: units, lang: lang)
        )
    }

    func getHourlyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?) async throws -> HourlyWeather {
        try await apiClient.sendRequest(
            WeatherAPISpec.getHourlyWeather(coords: coords, units: units, cnt: cnt, lang: lang)
        )
    }

    func getDailyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?) async throws -> DailyWeather {
        try await apiClient.sendRequest(
            WeatherAPISpec.getDailyWeather(coords: coords, units: units, cnt: cnt, lang: lang)
        )
    }

    func getCurrentAirPollution(coords: Coordinates) async throws -> AirPollution {
        try await apiClient.sendRequest(
            WeatherAPISpec.getCurrentAirPollution(coords: coords)
        )
    }
}
