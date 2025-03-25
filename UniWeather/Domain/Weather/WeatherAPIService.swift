//
//  CurrentWeatherAPIService.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

class WeatherAPIService: APIService {
    
    private func fetchWeatherData<T: Decodable>(spec: WeatherAPISpec) async throws -> T? {
        do {
            return try await apiClient?.sendRequest(spec) as? T
        } catch {
            print("Ошибка запроса: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getCurrentWeather(coords: Coordinates, units: Units? = nil, lang: Language? = nil)
    async throws -> CurrentWeather? {
        return try await fetchWeatherData(spec: .getCurrentWeather(coords: coords, units: units, lang: lang))
    }
    
    func getHourlyWeather(coords: Coordinates, units: Units? = nil, count: Int? = nil, lang: Language? = nil)
    async throws -> HourlyWeather? {
        return try await fetchWeatherData(spec: .getHourlyWeather(coords: coords, units: units, cnt: count, lang: lang))
    }
    
    func getDailyWeather(coords: Coordinates, units: Units? = nil, count: Int? = nil, lang: Language? = nil)
    async throws -> DailyWeather? {
        return try await fetchWeatherData(spec: .getDailyWeather(coords: coords, units: units, cnt: count, lang: lang))
    }
    
    func getCurrentAirPollution(coords: Coordinates)
    async throws -> AirPollution? {
        return try await fetchWeatherData(spec: .getCurrentAirPollution(coords: coords))
    }
    
    func getAirPollutionForecast(coords: Coordinates)
    async throws -> AirPollution? {
        return try await fetchWeatherData(spec: .getAirPollutionForecast(coords: coords))
    }
}

