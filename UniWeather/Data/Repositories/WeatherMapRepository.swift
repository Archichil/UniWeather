import APIClient
import Foundation
import WeatherMapService

final class WeatherMapRepository: WeatherMapRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient(baseURL: URL(string: WeatherMapAPISpec.baseURL)!)) {
        self.apiClient = apiClient
    }

    func getMapTile(layer: WeatherMapConfiguration.MapLayer, z: Int, x: Int, y: Int, date: Date) async throws -> Data {
        try await apiClient
            .sendRequest(
                WeatherMapAPISpec
                    .getMapTile(
                        layer: layer.rawValue,
                        z: z,
                        x: x,
                        y: y,
                        date: date
                    )
            )
    }
}
