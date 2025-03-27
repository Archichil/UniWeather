//
//  WeatherTileOverlay.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import MapKit

class WeatherTileOverlay: MKTileOverlay {
    let weatherMapService: WeatherMapAPIService
    let layer: WeatherMapConfiguration.MapLayer
    private var intensity: CGFloat = 0.5
    private var overlayColor: UIColor = .black
    
    init(weatherService: WeatherMapAPIService = WeatherMapAPIService(), layer: WeatherMapConfiguration.MapLayer) {
        self.weatherMapService = weatherService
        self.layer = layer
        super.init(urlTemplate: nil)
        
        self.canReplaceMapContent = false
        self.tileSize = CGSize(width: 256, height: 256)
    }
    
    @MainActor
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        Task {
            do {
                let data = try await fetchTileData(at: path)
                result(data, nil)
            } catch {
                result(nil, error)
            }
        }
    }
    
    private func fetchTileData(at path: MKTileOverlayPath) async throws -> Data {
        let cacheKey = "\(layer.rawValue).\(path.z).\(path.x).\(path.y).\(intensity)" as NSString
        
        let maxTileIndex = (1 << path.z) - 1
        guard path.x >= 0, path.x <= maxTileIndex, path.y >= 0, path.y <= maxTileIndex else {
            throw NetworkError.requestFailed(statusCode: 400)
        }
        
        guard let data = try await weatherMapService.getTileData(layer: layer, z: path.z, x: path.x, y: path.y, date: Date.now),
              let weatherImage = UIImage(data: data) else {
            throw NetworkError.invalidResponse
        }

        let finalImage = applySaturationOverlay(to: weatherImage)
        
        guard let finalData = finalImage.pngData() else {
            throw NetworkError.invalidResponse
        }
        
        return finalData
    }
    
    private func applySaturationOverlay(to image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: tileSize)
        return renderer.image { ctx in
            overlayColor.withAlphaComponent(intensity).setFill()
            ctx.fill(CGRect(origin: .zero, size: tileSize))
            image.draw(in: CGRect(origin: .zero, size: tileSize))
        }
    }
}
