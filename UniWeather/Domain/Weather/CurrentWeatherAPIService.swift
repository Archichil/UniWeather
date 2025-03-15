//
//  CurrentWeatherAPIService.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

class CurrentWeatherAPIService: APIService {
    func getCurrentWeather(
        coords: Coordinates,
        appId: String,
        units: Units? = nil,
        lang: Language? = nil
    ) async throws -> CurrentWeather? {
        let apiSpec: CurrentWeatherAPISpec = .getCurrentWeather(coords: coords,
                                                                appId: appId,
                                                                units: units,
                                                                lang: lang)
        do {
            let currentWeather = try await apiClient?.sendRequest(apiSpec)
            return currentWeather as? CurrentWeather
        } catch {
            print(error)
            return nil
        }
    }
}
