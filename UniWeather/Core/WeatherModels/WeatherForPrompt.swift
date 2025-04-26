//
//  WeatherForPrompt.swift
//  UniWeather
//
//  Created by Daniil on 24.03.25.
//

import APIClient

struct WeatherForPrompt {
    let temperature: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let windSpeed: Double
    let cloudiness: Int
    let precipitation: Double
    let weatherDescription: String
}
