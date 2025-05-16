//
//  WeatherInfoViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import Combine
import CoreLocation
import SwiftUI
import WeatherService

@MainActor
final class WeatherInfoViewModel: ObservableObject {
    private let weatherService = WeatherAPIService()

    @Published var currentWeather: CurrentWeather?
    @Published var hourlyWeather: HourlyWeather?
    @Published var dailyWeather: DailyWeather?
    @Published var airPollution: AirPollution?
    @Published var currentPlace: String?
    @Published var isLoaded = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    let coordinate: Coordinates
    private let geocoder = CLGeocoder()

    // MARK: - Initialization

    init(place: String? = "unknown", coordinate: Coordinates) {
        self.coordinate = coordinate
        self.currentPlace = place
    }

    // MARK: - Data loading

    func loadAllWeather(loadGeo: Bool = true) async {
        async let hourly = weatherService.getHourlyWeather(coords: coordinate, units: .metric, count: 25, lang: .ru)
        async let daily = weatherService.getDailyWeather(coords: coordinate, units: .metric, count: 14, lang: .ru)
        async let current = weatherService.getCurrentWeather(coords: coordinate, units: .metric, lang: .ru)
        async let pollution = weatherService.getCurrentAirPollution(coords: coordinate)
        do {
            isLoaded = false
            defer { isLoaded = true }
            (hourlyWeather, dailyWeather, currentWeather, airPollution) = try await (hourly, daily, current, pollution)
            if loadGeo {
                try await reverseGeocode(lat: coordinate.lat, lon: coordinate.lon)
            }
        } catch {
            isLoaded = false
            errorMessage = error.localizedDescription
            print("[DEBUG] Error loading all weather: \(error)")
        }
    }

    // MARK: - Helpers

    func reverseGeocode(lat: Double, lon: Double) async throws {
        let location = CLLocation(latitude: lat, longitude: lon)
        let geocoder = geocoder

        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first?.locality {
            currentPlace = placemark
        } else if let placemark = placemarks.first?.name {
            currentPlace = placemark
        }
    }
    
    static func reverseGeocode(coord: Coordinates) async throws -> String {
        let location = CLLocation(latitude: coord.lat, longitude: coord.lon)
        let geocoder = CLGeocoder()

        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first?.locality {
            return placemark
        } else if let placemark = placemarks.first?.name {
            return placemark
        }
        return ""
    }
}
