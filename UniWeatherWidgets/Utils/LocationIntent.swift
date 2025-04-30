//
//  LocationIntent.swift
//  UniWeather
//
//  Created by Daniil on 27.04.25.
//

import AppIntents
import WeatherService
import Intents

struct LocationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Настройки геопозиции"
    
    @Parameter(
        title: "Геопозиция",
        default: GeoOption.currentLocation,
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
        
        static var currentLocation: GeoOption {
            GeoOption(
                id: "current_location",
                name: "Текущее местоположение",
                coordinates: Coordinates(lon: 0.0, lat: 0.0)
            )
        }
        
        var isCurrentLocation: Bool {
            id == "current_location"
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
            .init(id: "current_location", name: "Текущее местоположение", coordinates: Coordinates(lon: 0, lat: 0)),
            .init(id: "1", name: "Минск", coordinates: Coordinates(lon: 27.5667, lat: 53.9)),
            .init(id: "2", name: "Москва", coordinates: Coordinates(lon: 37.6176, lat: 55.7558)),
        ]
        
        cachedGeolocations = geolocations
        return geolocations
    }
    
    func updateGeo(_ geolocations: [LocationIntent.GeoOption]) {
        cachedGeolocations = geolocations
    }
}

func resolveCoordinates(from configuration: LocationIntent) async  -> (coords: Coordinates, isCurrentLocation: Bool, location: String) {
    var coords = Coordinates(lon: 0, lat: 0)
    var isCurrentLocation = false
    var location: String?
    
    if let geo = configuration.geo {
        if geo.isCurrentLocation == true {
            let sharedDefaults = UserDefaults(suiteName: "group.com.kuhockovolec.UniWeather")!
            if let lat = sharedDefaults.value(forKey: "lastLatitude") as? Double,
               let lon = sharedDefaults.value(forKey: "lastLongitude") as? Double {
                coords = Coordinates(lon: lon, lat: lat)
                isCurrentLocation = true
                location = await getPlaceName(for: coords)
            }
        } else {
            coords = Coordinates(lon: geo.coordinates.lon, lat: geo.coordinates.lat)
            location = geo.name
        }
    }
    
    return (coords, isCurrentLocation, location ?? "Неизвестно")
}

func getPlaceName(for coords: Coordinates) async -> String? {
    let location = CLLocation(latitude: coords.lat, longitude: coords.lon)
    let geocoder = CLGeocoder()

    do {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        if let placemark = placemarks.first {
            return placemark.locality ?? placemark.name
        }
    } catch {
        print("Ошибка геокодирования: \(error.localizedDescription)")
    }

    return nil
}

