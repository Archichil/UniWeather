//
//  LocationIntent.swift
//  UniWeather
//
//  Created by Daniil on 27.04.25.
//

import AppIntents
import WeatherService

struct LocationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Настройки геопозиции"
    
    @Parameter(
        title: "Геопозиция",
        default: nil,
        optionsProvider: GeolocationOptionsProvider()
    )
    
    var geo: GeoOption?
    
    struct GeoOption: AppEntity, Identifiable {
        let id: String
        let name: String
        let coordinates: Coordinates
        
        static var typeDisplayRepresentation: TypeDisplayRepresentation {
            TypeDisplayRepresentation(name: "Геопозиция")
        }
        
        var displayRepresentation: DisplayRepresentation {
            DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name))
        }
        
        struct Query: EntityQuery {
            @MainActor
            func entities(for identifiers: [String]) async throws -> [GeoOption] {
                try await GeolocationManager.shared.getGeolocations()
                    .filter { identifiers.contains($0.id) }
            }
            
            @MainActor
            func suggestedEntities() async throws -> [GeoOption] {
                try await GeolocationManager.shared.getGeolocations()
            }
        }
        
        static var defaultQuery = Query()
    }
    
    struct GeolocationOptionsProvider: DynamicOptionsProvider {
        typealias Intent = LocationIntent
        
        @MainActor
        func results() async throws -> [GeoOption] {
            try await GeolocationManager.shared.getGeolocations()
        }
    }
}

@MainActor
class GeolocationManager {
    static let shared = GeolocationManager()
    private var cachedGeolocations: [LocationIntent.GeoOption]?
    
    func getGeolocations() async throws -> [LocationIntent.GeoOption] {
        if let cachedGeolocations = cachedGeolocations {
            return cachedGeolocations
        }
        
        let geolocations: [LocationIntent.GeoOption] = [
            .init(id: "1", name: "Минск", coordinates: Coordinates(lat: 53.9, lon: 27.5667)),
            .init(id: "2", name: "Москва", coordinates: Coordinates(lat: 55.7558, lon: 37.6176)),
        ]
        
        cachedGeolocations = geolocations
        return geolocations
    }
    
    func updateGeo(_ geolocations: [LocationIntent.GeoOption]) {
        cachedGeolocations = geolocations
    }
}
