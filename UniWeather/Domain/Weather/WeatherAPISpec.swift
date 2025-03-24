//
//  CurrentWeatherAPISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

enum WeatherAPISpec: APIClient.APISpec {
    case getCurrentWeather(coords: Coordinates, units: Units?, lang: Language?)
    case getHourlyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?)
    case getDailyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?)
    case getCurrentAirPollution(coords: Coordinates)
    case getAirPollutionForecast(coords: Coordinates)

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
        case .getCurrentWeather(_, let u, let l):
            units = u
            lang = l
            
        case .getHourlyWeather(_, let u, let cnt, let l),
             .getDailyWeather(_, let u, let cnt, let l):
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
        case .getCurrentWeather(let coords, _, _),
             .getHourlyWeather(let coords, _, _, _),
             .getDailyWeather(let coords, _, _, _),
             .getCurrentAirPollution(let coords),
             .getAirPollutionForecast(let coords):
            return [
                "lat": "\(coords.lat)",
                "lon": "\(coords.lon)",
                "appid": apiKey ?? ""
            ]
        }
    }
    
    private var apiKey: String? {
        get {
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
    
    var headers: [String : String]? {
        switch self {
        case .getCurrentWeather,
             .getHourlyWeather,
             .getDailyWeather,
             .getCurrentAirPollution,
             .getAirPollutionForecast:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? { nil }
}
