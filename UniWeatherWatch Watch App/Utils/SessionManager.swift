//
//  SessionManager.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import WatchConnectivity
import WeatherService

@MainActor
class SessionManager: NSObject, ObservableObject {
    static let shared = SessionManager()
    private var session: WCSession?
    
    @Published var receivedData: [String: Any] = [:]
    
    @Published var savedLocations: [LocationEntity] = []
    @Published var lastLocation: Coordinates?
    @Published var lastPlace: String = ""
    
    override init() {
        super.init()
        loadLastLocation()
        loadCachedLocations()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
}

// MARK: - WCSessionDelegate
@MainActor
extension SessionManager: @preconcurrency WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Ошибка активации WCSession: \(error.localizedDescription)")
            return
        }
        print("Сессия активирована (Watch)")
    }
    
    @MainActor
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let lastLat = applicationContext["lastLatitude"] as? Double,
               let lastLon = applicationContext["lastLongitude"] as? Double,
               let lastPlace = applicationContext["lastPlace"] as? String {
                self.lastLocation = Coordinates(lat: lastLat, lon: lastLon)
                self.lastPlace = lastPlace
                self.cacheLastLocation(location: self.lastLocation!, lastPlace: lastPlace)
                print("last updated")
            }
            
            if let data = applicationContext["savedLocations"] as? Data,
               let savedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data) {
                self.savedLocations = savedLocations
                self.cacheLocations(savedLocations)
                print("saved updated")
            }
        }
    }
    
    func cacheLocations(_ savedLocations: [LocationEntity]) {
        if let data = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(data, forKey: "cachedLocations")
        }
    }
    
    func loadCachedLocations() {
        if let data = UserDefaults.standard.data(forKey: "cachedLocations"),
           let decoded = try? JSONDecoder().decode([LocationEntity].self, from: data) {
            savedLocations = decoded
        }
    }
    
    func cacheLastLocation(location: Coordinates, lastPlace: String) {
        UserDefaults.standard.set(location.lon, forKey: "lastLon")
        UserDefaults.standard.set(location.lat, forKey: "lastLat")
        UserDefaults.standard.set(lastPlace, forKey: "lastPlace")
    }
    
    func loadLastLocation() {
        let storage = UserDefaults.standard
        
        if storage.object(forKey: "lastLat") != nil && storage.object(forKey: "lastLon") != nil {
            let lat = storage.double(forKey: "lastLat")
            let lon = storage.double(forKey: "lastLon")
            let lastPlace = storage.string(forKey: "lastPlace")
            lastLocation = Coordinates(lat: lat, lon: lon)
            self.lastPlace = lastPlace ?? "Неизвестно"
            return
        }
        
        lastLocation = Coordinates(lat: 53.54, lon: 27.33)
    }
}
