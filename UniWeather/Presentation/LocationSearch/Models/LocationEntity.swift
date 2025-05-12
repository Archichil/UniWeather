//
//  LocationEntity.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 11.05.25.
//

import SwiftData
import SwiftUI

@Model
final class LocationEntity: Identifiable, Codable {
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
        timestamp = Date()
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, cityName, latitude, longitude, timestamp
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(cityName, forKey: .cityName)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
