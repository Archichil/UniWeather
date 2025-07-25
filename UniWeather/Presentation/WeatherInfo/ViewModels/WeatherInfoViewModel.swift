//
//  WeatherInfoViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import APIClient
import Combine
import CoreLocation
import SwiftUI
import WeatherService

@MainActor
final class WeatherInfoViewModel: ObservableObject {
    private let weatherService = APIClient(
        baseURL: URL(string: WeatherAPISpec.baseURL)!
    )
    private let geocoder = CLGeocoder()

    @Published var currentWeather: CurrentWeather?
    @Published var hourlyWeather: HourlyWeather?
    @Published var dailyWeather: DailyWeather?
    @Published var airPollution: AirPollution?
    @Published var currentPlace: String?
    @Published var isLoaded = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    let coordinate: Coordinates

    // MARK: - Initialization

    init(coordinate: Coordinates) {
        self.coordinate = coordinate
    }

    // MARK: - Data loading

    func loadAllWeather() async {
        async let hourly: HourlyWeather = weatherService.sendRequest(
            WeatherAPISpec
                .getHourlyWeather(
                    coords: coordinate,
                    units: .metric,
                    cnt: 25,
                    lang: .ru
                )
        )
        async let daily: DailyWeather = weatherService.sendRequest(
            WeatherAPISpec
                .getDailyWeather(
                    coords: coordinate,
                    units: .metric,
                    cnt: 14,
                    lang: .ru
                )
        )
        async let current: CurrentWeather = weatherService.sendRequest(
            WeatherAPISpec
                .getCurrentWeather(
                    coords: coordinate,
                    units: .metric,
                    lang: .ru
                )
        )
        async let pollution: AirPollution = weatherService.sendRequest(
            WeatherAPISpec
                .getCurrentAirPollution(coords: coordinate)
        )
        do {
            isLoaded = false
            defer { isLoaded = true }
            (hourlyWeather, dailyWeather, currentWeather, airPollution) = try await (hourly, daily, current, pollution)
            try await reverseGeocode()
        } catch {
            isLoaded = false
            errorMessage = error.localizedDescription
            print("[DEBUG] Error loading all weather: \(error)")
        }
    }

    // MARK: - Helpers

    func reverseGeocode() async throws {
        let location = CLLocation(latitude: coordinate.lat, longitude: coordinate.lon)
        let geocoder = geocoder

        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first?.locality {
            currentPlace = placemark
        } else if let placemark = placemarks.first?.name {
            currentPlace = placemark
        }
    }
}
