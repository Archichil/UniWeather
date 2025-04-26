//
//  WeatherTileOverlay.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import MapKit
import APIClient

class WeatherTileOverlay: MKTileOverlay {
    private var cache = NSCache<NSString, NSData>()
    private var intensity: CGFloat = 0.5
    private var overlayColor: UIColor = .black

    let weatherMapService: WeatherMapAPIService
    let layer: WeatherMapConfiguration.MapLayer
    var date: Date

    init(
        weatherService: WeatherMapAPIService = WeatherMapAPIService(),
        layer: WeatherMapConfiguration.MapLayer,
        date: Date
    ) {
        weatherMapService = weatherService
        self.layer = layer
        self.date = date
        super.init(urlTemplate: nil)

        canReplaceMapContent = false
        tileSize = CGSize(width: 256, height: 256)
        cache.countLimit = 500
    }

    @MainActor
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        Task {
            do {
                let data = try await fetchTileData(at: path, for: date)
                result(data, nil)
            } catch {
                result(nil, error)
            }
        }
    }

    private func cacheKey(for path: MKTileOverlayPath, date: Date) -> NSString {
        "\(layer.rawValue).\(path.z).\(path.x).\(path.y).\(date.timeIntervalSince1970)" as NSString
    }

    private func applySaturationOverlay(to image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: tileSize)
        return renderer.image { ctx in
            overlayColor.withAlphaComponent(intensity).setFill()
            ctx.fill(CGRect(origin: .zero, size: tileSize))
            image.draw(in: CGRect(origin: .zero, size: tileSize))
        }
    }

    private func fetchTileData(at path: MKTileOverlayPath, for date: Date) async throws -> Data {
        let cacheKey = cacheKey(for: path, date: date)

        if let cachedData = cache.object(forKey: cacheKey) {
            return cachedData as Data
        }

        let maxTileIndex = (1 << path.z) - 1
        guard path.x >= 0, path.x <= maxTileIndex, path.y >= 0, path.y <= maxTileIndex else {
            throw NetworkError.requestFailed(statusCode: 400)
        }

        guard let data = try await weatherMapService.getTileData(layer: layer, z: path.z, x: path.x, y: path.y, date: date),
              let weatherImage = UIImage(data: data)
        else {
            throw NetworkError.invalidResponse
        }

        let finalImage = applySaturationOverlay(to: weatherImage)

        guard let finalData = finalImage.pngData() else {
            throw NetworkError.invalidResponse
        }

        cache.setObject(finalData as NSData, forKey: cacheKey)
        return finalData
    }

    func setCache(_ cache: NSCache<NSString, NSData>) {
        self.cache = cache
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
