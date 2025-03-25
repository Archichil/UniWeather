//
//  WeatherMapAPISpec.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 24.03.25.
//

import Foundation

enum WeatherMapAPISpec: APIClient.APISpec {
    // FIXME: date - use Date type?
    case getMapTile(layer: WeatherMapConfiguration.MapLayer, z: Int, x: Int, y: Int, opacity: Double, fillBound: Bool, date: Date)

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

    private var queryParams: [String: String] {
        switch self {
        case let .getMapTile(_, _, _, _, opacity, fillBound, date):
            [
                "opacity": "\(opacity)",
                "fillBound": "\(fillBound)",
                "date": "\(Int(date.timeIntervalSince1970))",
                "appid": "\(apiKey ?? "")",
            ]
        }
    }

    var endpoint: String {
        switch self {
        case let .getMapTile(layer, z, x, y, _, _, _):
            let path = "/\(layer.rawValue)/\(z)/\(x)/\(y)"
            let queryString = queryParams
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            return path + (queryString.isEmpty ? "" : "?\(queryString)")
        }
    }

    var method: APIClient.HttpMethod {
        switch self {
        case .getMapTile:
            .get
        }
    }

    var returnType: any DecodableType.Type {
        switch self {
        case .getMapTile:
            Data.self
        }
    }

    var headers: [String: String]? { [:] }

    var body: Data? { nil }
}
