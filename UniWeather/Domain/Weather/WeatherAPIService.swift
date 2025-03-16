//
//  CurrentWeatherAPIService.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

class WeatherAPIService: APIService {
    func getCurrentWeather(
        coords: Coordinates,
        appId: String,
        units: Units? = nil,
        lang: Language? = nil
    ) async throws -> CurrentWeather? {
        let apiSpec: WeatherAPISpec = .getCurrentWeather(coords: coords, appId: appId, units: units, lang: lang)
        do {
            let currentWeather = try await apiClient?.sendRequest(apiSpec)
            return currentWeather as? CurrentWeather
        } catch {
            print(error)
            return nil
        }
    }
    
    func getHourlyWeather(
        coords: Coordinates,
        appId: String,
        units: Units? = nil,
        count: Int? = nil,
        lang: Language? = nil
    ) async throws -> HourlyWeather? {
        let apiSpec: WeatherAPISpec = .getHourlyWeather(coords: coords, appId: appId, units: units, cnt: count, lang: lang)
        do {
            let hourlyWeather = try await apiClient?.sendRequest(apiSpec)
            return hourlyWeather as? HourlyWeather
        } catch {
            print(error)
            return nil
        }
    }
    
    func getDailyWeather(
        coords: Coordinates,
        appId: String,
        units: Units? = nil,
        count: Int? = nil,
        lang: Language? = nil
    ) async throws -> DailyWeather? {
        let apiSpec: WeatherAPISpec = .getDailyWeather(coords: coords, appId: appId, units: units, cnt: count, lang: lang)
        do {
            let dailyWeather = try await apiClient?.sendRequest(apiSpec)
            return dailyWeather as? DailyWeather
        } catch {
            print(error)
            return nil
        }
    }
}
