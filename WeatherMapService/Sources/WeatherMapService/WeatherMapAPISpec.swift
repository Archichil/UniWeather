import APIClient
import Foundation
import WeatherService

public enum WeatherMapAPISpec: APIClient.APISpecification {
    public static let baseURL: String = "https://maps.openweathermap.org/maps/2.0/weather"

    case getMapTile(layer: WeatherMapConfiguration.MapLayer, z: Int, x: Int, y: Int, opacity: Double = 0.8, fillBound: Bool = false, date: Date)

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

    public var queryParameters: [String: String]? {
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

    public var endpoint: String {
        switch self {
        case let .getMapTile(layer, z, x, y, _, _, _):
            "/\(layer.rawValue)/\(z)/\(x)/\(y)"
        }
    }

    public var method: APIClient.HttpMethod {
        switch self {
        case .getMapTile:
            .get
        }
    }

    public var headers: [String: String]? { nil }

    public var body: Data? { nil }
}
