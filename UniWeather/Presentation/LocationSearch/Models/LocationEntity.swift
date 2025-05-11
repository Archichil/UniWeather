//
//  LocationStore.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 11.05.25.
//

import SwiftUI
import SwiftData
import CoreLocation

@Model
final class LocationEntity: Identifiable {
    @Attribute(.unique) var id: UUID
    var cityName: String?
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(id: UUID = UUID(), cityName: String? = nil, latitude: Double, longitude: Double) {
        self.id = id
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date() // Initialize with current date
    }
}
