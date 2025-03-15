//
//  CurrentWeatherAPISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

enum WeatherAPISpec: APIClient.APISpec {
    case getCurrentWeather(coords: Coordinates, appId: String, units: Units?, lang: Language?)
    case getHourlyWeather(coords: Coordinates, appId: String, units: Units?, cnt: Int?, lang: Language?)

    private var path: String {
        switch self {
        case .getCurrentWeather: return "/weather"
        case .getHourlyWeather: return "/forecast/hourly"
        }
    }

    private var queryParameters: [String: String] {
        var params = commonParams()
        
        switch self {
        case .getHourlyWeather(_, _, _, let cnt, _):
            if let cnt = cnt { params["cnt"] = "\(cnt)" }
        default:
            break
        }

        return params
    }

    private func commonParams() -> [String: String] {
        var params: [String: String] = [:]
        
        switch self {
        case .getCurrentWeather(let coords, let appId, let units, let lang),
             .getHourlyWeather(let coords, let appId, let units, _, let lang):
            params["lat"] = "\(coords.lat)"
            params["lon"] = "\(coords.lon)"
            params["appid"] = appId
            if let units = units { params["units"] = units.rawValue }
            if let lang = lang { params["lang"] = lang.rawValue }
        }

        return params
    }

    var endpoint: String {
        let queryString = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return path + (queryString.isEmpty ? "" : "?\(queryString)")
    }

    var method: APIClient.HttpMethod { .get }
    
    var returnType: DecodableType.Type {
        switch self {
        case .getCurrentWeather: return CurrentWeather.self
        case .getHourlyWeather: return HourlyWeather.self
        }
    }
    
    var body: Data? { nil }
}
