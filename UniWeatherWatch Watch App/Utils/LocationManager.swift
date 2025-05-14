//
//  LocationManager.swift
//  UniWeather
//
//  Created by Daniil on 13.05.25.
//

import Foundation
import WeatherService

func getLocationFromPhone() -> Coordinates {
    var coords = Coordinates(lat: 0, lon: 0)
    
    let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
    if let lat = sharedDefaults.value(forKey: "lastLatitude") as? Double,
       let lon = sharedDefaults.value(forKey: "lastLongitude") as? Double
    {
        coords = Coordinates(lat: lat, lon: lon)
    }
    print(coords)
    return coords
}
