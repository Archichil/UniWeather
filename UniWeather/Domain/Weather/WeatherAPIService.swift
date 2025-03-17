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
    
    func getCurrentWeather(coords: Coordinates, appId: String, units: Units? = nil, lang: Language? = nil)
    async throws -> CurrentWeather? {
        return try await fetchWeatherData(spec: .getCurrentWeather(coords: coords, appId: appId, units: units, lang: lang))
    }
    
    func getHourlyWeather(coords: Coordinates, appId: String, units: Units? = nil, count: Int? = nil, lang: Language? = nil)
    async throws -> HourlyWeather? {
        return try await fetchWeatherData(spec: .getHourlyWeather(coords: coords, appId: appId, units: units, cnt: count, lang: lang))
    }
    
    func getDailyWeather(coords: Coordinates, appId: String, units: Units? = nil, count: Int? = nil, lang: Language? = nil)
    async throws -> DailyWeather? {
        return try await fetchWeatherData(spec: .getDailyWeather(coords: coords, appId: appId, units: units, cnt: count, lang: lang))
    }
    
    func getCurrentAirPollution(coords: Coordinates, appId: String)
    async throws -> AirPollution? {
        return try await fetchWeatherData(spec: .getCurrentAirPollution(coords: coords, appId: appId))
    }
    
    func getAirPollutionForecast(coords: Coordinates, appId: String)
    async throws -> AirPollution? {
        return try await fetchWeatherData(spec: .getAirPollutionForecast(coords: coords, appId: appId))
    }
}

