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
    case getDailyWeather(coords: Coordinates, appId: String, units: Units?, cnt: Int?, lang: Language?)
    case getCurrentAirPollution(coords: Coordinates, appId: String)
    case getAirPollutionForecast(coords: Coordinates, appId: String)

    private var path: String {
        switch self {
        case .getCurrentWeather: return "/weather"
        case .getHourlyWeather: return "/forecast/hourly"
        case .getDailyWeather: return "/forecast/daily"
        case .getCurrentAirPollution: return "/air_pollution"
        case .getAirPollutionForecast: return "/air_pollution/forecast"
        }
    }
    
    private var queryParameters: [String: String] {
        var params = commonParams()

        var units: Units? = nil
        var lang: Language? = nil
        
        switch self {
        case .getCurrentWeather(_, _, let u, let l):
            units = u
            lang = l
            
        case .getHourlyWeather(_, _, let u, let cnt, let l),
             .getDailyWeather(_, _, let u, let cnt, let l):
            units = u
            lang = l
            if let cnt = cnt { params["cnt"] = "\(cnt)" }
            
        default: break
        }
        
        if let units = units { params["units"] = units.rawValue }
        if let lang = lang { params["lang"] = lang.rawValue }

        return params
    }

    private func commonParams() -> [String: String] {
        switch self {
        case .getCurrentWeather(let coords, let appId, _, _),
             .getHourlyWeather(let coords, let appId, _, _, _),
             .getDailyWeather(let coords, let appId, _, _, _),
             .getCurrentAirPollution(let coords, let appId),
             .getAirPollutionForecast(let coords, let appId):
            return [
                "lat": "\(coords.lat)",
                "lon": "\(coords.lon)",
                "appid": appId
            ]
        }
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
        case .getDailyWeather: return DailyWeather.self
        case .getCurrentAirPollution,
             .getAirPollutionForecast:
            return AirPollution.self
        }
    }
    
    var body: Data? { nil }
}
