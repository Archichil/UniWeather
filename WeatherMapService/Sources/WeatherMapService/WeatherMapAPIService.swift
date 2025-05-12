//
//  WeatherMapAPIService.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 24.03.25.
//

import APIClient
import Foundation

public class WeatherMapAPIService: APIService {
    private let baseURL = URL(string: "https://maps.openweathermap.org/maps/2.0/weather")!

    public init() {
        super.init(apiClient: APIClient(baseURL: baseURL))
    }

    private func fetch<T: Decodable>(spec: WeatherMapAPISpec) async throws -> T? {
        do {
            return try await apiClient?.sendRequest(spec) as? T
        } catch {
            print("Failed to send request: \(error.localizedDescription)")
            return nil
        }
    }

    public func getTileData(layer: WeatherMapConfiguration.MapLayer, z: Int, x: Int, y: Int, opacity: Double = 0.8, fillBound: Bool = false, date: Date)
        async throws -> Data?
    {
        try await fetch(spec: .getMapTile(layer: layer, z: z, x: x, y: y, opacity: opacity, fillBound: fillBound, date: date))
    }
}
