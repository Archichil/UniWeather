//
//  SessionManager.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import WatchConnectivity
import WeatherService

class SessionManager: NSObject, ObservableObject {
    static let shared = SessionManager()
    private var session: WCSession?
    
    @Published var receivedData: [String: Any] = [:]
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
}

// MARK: - WCSessionDelegate
extension SessionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Ошибка активации WCSession: \(error.localizedDescription)")
            return
        }
        print("Сессия активирована (Watch)")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let lastLat = applicationContext["lastLatitude"] as? Double,
           let lastLon = applicationContext["lastLongitude"] as? Double {
            print(lastLat, lastLon)
        }
        
        if let data = applicationContext["savedLocations"] as? Data,
            let savedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data)
        {
            for location in savedLocations {
                print(location.longitude, location.latitude)
            }
        }
    }
}
