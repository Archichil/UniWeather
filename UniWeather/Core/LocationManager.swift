//
//  LocationManager.swift
//  UniWeather
//
//  Created by Daniil on 28.04.25.
//

import CoreLocation
import WidgetKit

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
        manager.distanceFilter = 1000
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
            print("Доступ к геолокации запрещен")
        case .restricted:
            print("Доступ к геолокации ограничен")
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async { [unowned self] in
                self.lastLocation = location
                self.locationContinuation?.resume(returning: location)
                self.locationContinuation = nil
                saveLocationToSharedStorage()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[DEBUG] Failed to get location:", error)
        self.locationContinuation?.resume(returning: CLLocation(latitude: 53.893009, longitude: 27.567444)) // fallback
        self.locationContinuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            self.locationContinuation?.resume(returning: CLLocation(latitude: 53.893009, longitude: 27.567444)) // fallback
            self.locationContinuation = nil
        }
    }

    private func saveLocationToSharedStorage() {
        guard let location = lastLocation else { return }
        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather1")!
        sharedDefaults.set(location.coordinate.latitude, forKey: "lastLatitude")
        sharedDefaults.set(location.coordinate.longitude, forKey: "lastLongitude")
        print("Сохранены координаты: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func requestLocationUpdateInBackground() {
        manager.requestLocation()
    }
}
