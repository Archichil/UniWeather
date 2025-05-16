//
//  LocationManager.swift
//  UniWeather
//
//  Created by Daniil on 28.04.25.
//

import CoreLocation
import WidgetKit
import WatchConnectivity
import WeatherService

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 3000
    }

    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func awaitLocation() async -> CLLocation {
        if let loc = lastLocation {
            return loc
        }

        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation

            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.requestLocation()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                continuation.resume(returning: CLLocation(latitude: 53.893009, longitude: 27.567444)) // fallback
                self.locationContinuation = nil
            default:
                break
            }
        }
    }

    private func checkAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied:
            print("[DEBUG] Geolocation access is denied")
        case .restricted:
            print("[DEBUG] Geolocation access is restricted")
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async { [unowned self] in
                lastLocation = location
                locationContinuation?.resume(returning: location)
                locationContinuation = nil
                Task {
                    await saveLocationToSharedStorage()
                }
            }
        }
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("[DEBUG] Failed to get location:", error)
        locationContinuation?.resume(returning: CLLocation(latitude: 53.893009, longitude: 27.567444)) // fallback
        locationContinuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            locationContinuation?.resume(returning: CLLocation(latitude: 53.893009, longitude: 27.567444)) // fallback
            locationContinuation = nil
        }
    }

    private func saveLocationToSharedStorage() async {
        guard let location = lastLocation else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
        let place = try? await WeatherInfoViewModel.reverseGeocode(coord: Coordinates(lat: lat, lon: lon))
        sharedDefaults.set(lat, forKey: "lastLatitude")
        sharedDefaults.set(lon, forKey: "lastLongitude")
        print("[DEBUG] Saved coordinates to the UD: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        WidgetCenter.shared.reloadAllTimelines()
        
        let locationData: [String: Any] = [
            "lastLatitude": lat,
            "lastLongitude": lon,
            "lastPlace": place ?? "Неизвестно"
        ]
        
        await AppDelegate.sendLocatisonToWatch(locationData)
    }

    func requestLocationUpdateInBackground() {
        manager.requestLocation()
    }
}
