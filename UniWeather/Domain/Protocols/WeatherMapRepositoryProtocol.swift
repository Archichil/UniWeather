import Foundation
import WeatherMapService

protocol WeatherMapRepositoryProtocol {
    func getMapTile(
        layer: WeatherMapConfiguration.MapLayer,
        z: Int,
        x: Int,
        y: Int,
        date: Date
    ) async throws -> Data
}
