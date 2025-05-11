//
//  LocationManager.swift
//  UniWeather
//
//  Created by Daniil on 28.04.25.
//

//import CoreLocation
//import Foundation
//import WidgetKit
//
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    @Published var lastLocation: CLLocation?
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func requestLocationPermission() {
//        if manager.authorizationStatus == .notDetermined {
//            manager.requestAlwaysAuthorization()
//        } else {
//            checkAuthorization()
//        }
//    }
//    
//    private func checkAuthorization() {
//        switch manager.authorizationStatus {
//        case .authorizedAlways, .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//        case .denied:
//            print("Доступ к геолокации запрещен")
//        case .restricted:
//            print("Доступ к геолокации ограничен")
//        case .notDetermined:
//            manager.requestAlwaysAuthorization()
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastLocation = locations.last
//        saveLocationToSharedStorage()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Ошибка получения геолокации: \(error.localizedDescription)")
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationStatus = manager.authorizationStatus
//        checkAuthorization()
//    }
//    
//    private func saveLocationToSharedStorage() {
//        guard let location = lastLocation else { return }
//        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
//        sharedDefaults.set(location.coordinate.latitude, forKey: "lastLatitude")
//        sharedDefaults.set(location.coordinate.longitude, forKey: "lastLongitude")
//
//    }
//}

import CoreLocation
import Combine
import WidgetKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestAlwaysAuthorization()
        } else {
            checkAuthorization()
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
        lastLocation = locations.last
        saveLocationToSharedStorage()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения геолокации: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        checkAuthorization()
    }
    
    private func saveLocationToSharedStorage() {
        guard let location = lastLocation else { return }
        let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
        sharedDefaults.set(location.coordinate.latitude, forKey: "lastLatitude")
        sharedDefaults.set(location.coordinate.longitude, forKey: "lastLongitude")
        print("Сохранены координаты: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func requestLocationUpdateInBackground() {
        manager.requestLocation()
    }
}
