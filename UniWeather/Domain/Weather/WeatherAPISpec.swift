//
//  WeatherAPISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation
import APIClient

enum WeatherAPISpec: APIClient.APISpec {
    case getCurrentWeather(coords: Coordinates, units: Units?, lang: Language?)
    case getHourlyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?)
    case getDailyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?)
    case getCurrentAirPollution(coords: Coordinates)
    case getAirPollutionForecast(coords: Coordinates)

    private var path: String {
        switch self {
        case .getCurrentWeather: "/weather"
        case .getHourlyWeather: "/forecast/hourly"
        case .getDailyWeather: "/forecast/daily"
        case .getCurrentAirPollution: "/air_pollution"
        case .getAirPollutionForecast: "/air_pollution/forecast"
        }
    }

    private var queryParameters: [String: String] {
        var params = commonParams()

        var units: Units? = nil
        var lang: Language? = nil

        switch self {
        case let .getCurrentWeather(_, u, l):
            units = u
            lang = l

        case let .getHourlyWeather(_, u, cnt, l),
             let .getDailyWeather(_, u, cnt, l):
            units = u
            lang = l
            if let cnt { params["cnt"] = "\(cnt)" }

        default: break
        }

        if let units { params["units"] = units.rawValue }
        if let lang { params["lang"] = lang.rawValue }

        return params
    }

    private func commonParams() -> [String: String] {
        switch self {
        case let .getCurrentWeather(coords, _, _),
             let .getHourlyWeather(coords, _, _, _),
             let .getDailyWeather(coords, _, _, _),
             let .getCurrentAirPollution(coords),
             let .getAirPollutionForecast(coords):
            [
                "lat": "\(coords.lat)",
                "lon": "\(coords.lon)",
                "appid": apiKey ?? "",
            ]
        }
    }

    private var apiKey: String? {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            print("Config.plist not found.")
            return nil
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "OPENWEATHERMAP_API_KEY") as? String else {
            print("OPENWEATHERMAP_API_KEY not found in Config.plist.")
            return nil
        }
        return value
    }

    var endpoint: String {
        let queryString = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return path + (queryString.isEmpty ? "" : "?\(queryString)")
    }

    var method: APIClient.HttpMethod { .get }

    var returnType: DecodableType.Type {
        switch self {
        case .getCurrentWeather: CurrentWeather.self
        case .getHourlyWeather: HourlyWeather.self
        case .getDailyWeather: DailyWeather.self
        case .getCurrentAirPollution,
             .getAirPollutionForecast:
            AirPollution.self
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getCurrentWeather,
             .getHourlyWeather,
             .getDailyWeather,
             .getCurrentAirPollution,
             .getAirPollutionForecast:
            ["Content-Type": "application/json"]
        }
    }

    var body: Data? { nil }
}
