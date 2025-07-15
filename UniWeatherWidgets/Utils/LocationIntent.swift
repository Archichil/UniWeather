//
//  LocationIntent.swift
//  UniWeather
//
//  Created by Daniil on 27.04.25.
//

import AppIntents
import Intents
import MapKit
import WeatherService

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
                coordinates: Coordinates(lat: 0.0, lon: 0.0)
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
        if let cachedGeolocations {
            return cachedGeolocations
        }

        var geolocations: [LocationIntent.GeoOption] = [
            .init(id: "current_location", name: "Текущее местоположение", coordinates: Coordinates(lat: 0, lon: 0)),
        ]

        let savedLocations = await withCheckedContinuation { continuation in
            getUserDefaultsLocations { result in
                continuation.resume(returning: result)
            }
        }

        geolocations += savedLocations
        cachedGeolocations = geolocations
        return geolocations
    }

    func updateGeo(_ geolocations: [LocationIntent.GeoOption]) {
        cachedGeolocations = geolocations
    }

    func getUserDefaultsLocations(completion: @escaping ([LocationIntent.GeoOption]) -> Void) {
        let sharedDefaults = UserDefaults.appSuite

        guard let data = sharedDefaults.data(forKey: "savedLocations"),
              let savedLocations = try? JSONDecoder().decode([LocationEntity].self, from: data)
        else {
            completion([])
            return
        }

        Task {
            var results: [LocationIntent.GeoOption] = []

            await withTaskGroup(of: LocationIntent.GeoOption?.self) { group in
                for entity in savedLocations {
                    group.addTask {
                        let coords = Coordinates(lat: entity.latitude, lon: entity.longitude)
                        let name = await self.reverseGeocode(coordinates: coords)
                        return LocationIntent.GeoOption(id: entity.id.uuidString, name: name, coordinates: coords)
                    }
                }

                for await result in group {
                    if let option = result {
                        results.append(option)
                    }
                }
            }

            completion(results)
        }
    }

    func reverseGeocode(coordinates: Coordinates) async -> String {
        let location = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first?.locality {
                return placemark
            } else if let placemark = placemarks.first?.name {
                return placemark
            }
        } catch {
            print("Reverse geocoding failed: \(error.localizedDescription)")
        }

        return "Unknown"
    }
}

func resolveCoordinates(from configuration: LocationIntent) async -> (coords: Coordinates, isCurrentLocation: Bool, location: String) {
    var coords = Coordinates(lat: 0, lon: 0)
    var isCurrentLocation = false
    var location: String?

    if let geo = configuration.geo {
        if geo.isCurrentLocation == true {
            let sharedDefaults = UserDefaults.appSuite
            if let lat = sharedDefaults.value(forKey: "lastLatitude") as? Double,
               let lon = sharedDefaults.value(forKey: "lastLongitude") as? Double
            {
                coords = Coordinates(lat: lat, lon: lon)
                isCurrentLocation = true
                location = await getPlaceName(for: coords)
            }
        } else {
            coords = Coordinates(lat: geo.coordinates.lat, lon: geo.coordinates.lon)
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
