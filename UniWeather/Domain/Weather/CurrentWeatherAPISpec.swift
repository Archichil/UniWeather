//
//  CurrentWeatherAPISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

enum CurrentWeatherAPISpec: APIClient.APISpec {
    case getCurrentWeather(coords: Coordinates,
                           appId: String,
                           units: Units?,
                           lang: Language?)

    var endpoint: String {
        switch self {
        case .getCurrentWeather(let coords, let appid, let units, let lang):
            var urlString = "/weather?lat=\(coords.lat)&lon=\(coords.lon)&appid=\(appid)"
            
            if let lang = lang { urlString += "&lang=\(lang.rawValue)" }
            if let units = units { urlString += "&units=\(units.rawValue)"
}
            print(urlString)
            return urlString
        }
    }

    var method: APIClient.HttpMethod {
        switch self {
        case .getCurrentWeather:
            return .get
        }
    }

    var returnType: DecodableType.Type {
        switch self {
        case .getCurrentWeather:
            return CurrentWeather.self
        }
    }

    var body: Data? {
        switch self {
        case .getCurrentWeather:
            return nil
        }
    }
}
