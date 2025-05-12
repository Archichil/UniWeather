//
//  WeatherInfoViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import WeatherService
import SwiftUI
import CoreLocation
import Combine

@MainActor
final class WeatherInfoViewModel: ObservableObject {
    private let weatherService = WeatherAPIService()
    private let geocoder = CLGeocoder()
    
    @Published var currentWeather: CurrentWeather?
    @Published var hourlyWeather: HourlyWeather?
    @Published var dailyWeather: DailyWeather?
    @Published var airPollution: AirPollution?
    @Published var currentPlace: String?
    @Published var isLoaded = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let coordinate: Coordinates
    
    // MARK: - Initialization
    
    init(coordinate: Coordinates) {
        self.coordinate = coordinate
    }
    
    // MARK: - Data loading
    
    func loadAllWeather() async {
        
        async let hourly = weatherService.getHourlyWeather(coords: coordinate, units: .metric, count: 25)
        async let daily = weatherService.getDailyWeather(coords: coordinate, units: .metric, count: 14)
        async let current = weatherService.getCurrentWeather(coords: coordinate, units: .metric)
        async let pollution = weatherService.getCurrentAirPollution(coords: coordinate)
        do {
            isLoaded = false
            defer { isLoaded = true }
            (hourlyWeather, dailyWeather, currentWeather, airPollution) = try await (hourly, daily, current, pollution)
            try await reverseGeocode()
        } catch {
            isLoaded = false
            self.errorMessage = error.localizedDescription
            print("Error loading weather data: \(error)")
        }
    }
    
    // MARK: - Helpers

    func reverseGeocode() async throws {
        let location = CLLocation(latitude: coordinate.lat, longitude: coordinate.lon)
        let geocoder = self.geocoder

        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first?.locality {
            currentPlace = placemark
        } else if let placemark = placemarks.first?.name {
            currentPlace = placemark
        }
    }
}
