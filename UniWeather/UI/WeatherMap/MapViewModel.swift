//
//  MapViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 23.03.25.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var region = MapRegion()
    @Published var errorMessage: String?
    @Published var selectedLayer: WeatherMapConfiguration.MapLayer = .accumulatedPrecipitation {
        didSet {
            if oldValue != selectedLayer {
                currentTileOverlay = createTileOverlay()
            }
        }
    }
    
    @Published private(set) var isBackwardDisabled: Bool = true
    @Published private(set) var isForwardDisabled: Bool = false
    @Published private(set) var date: Date = Date.now.roundedToNearestHour() {
        didSet {
            currentTileOverlay = createTileOverlay()
            updateButtonsState()
        }
    }
    
    @Published var currentTileOverlay: WeatherTileOverlay? {
        didSet {
            // Be sure that cache will be cleared when switching to other layers
            if let oldValue = oldValue, oldValue.layer != selectedLayer {
                oldValue.clearCache()
            }
        }
    }
    @Published var isUIVisible: Bool = true
    private let initialDate: Date
    private var hideTimer: Timer?
    private var cache = NSCache<NSString, NSData>()
    
    init() {
        initialDate = Date.now.roundedToNearestHour()
        self.currentTileOverlay = createTileOverlay()
        self.updateButtonsState()
        cache.countLimit = 1000
    }
    
    private func updateButtonsState() {
        let pastDate = date.addingTimeInterval(-3 * 3600)
        isBackwardDisabled = pastDate.timeIntervalSince(initialDate) < 0
        
        let futureDate = date.addingTimeInterval(3 * 3600)
        isForwardDisabled = futureDate.timeIntervalSince(initialDate) > 24 * 3600
    }
    
    private func createTileOverlay() -> WeatherTileOverlay {
        let overlay = WeatherTileOverlay(layer: selectedLayer, date: date)
        overlay.setCache(cache)
        return overlay
    }
        
    func stepForward() {
        userDidInteract()
        let newDate = date.addingTimeInterval(3 * 3600)
        if newDate.timeIntervalSince(initialDate) <= 24 * 3600 {
            date = newDate
        }
    }
        
    func stepBackward() {
        userDidInteract()
        let newDate = date.addingTimeInterval(-3 * 3600)
        if newDate.timeIntervalSince(initialDate) >= 0 {
            date = newDate
        }
    }
    
    func updateRegion(latitude: Double, longitude: Double, zoomLevel: Int) {
        let regionChanged = region.centerLatitude != latitude ||
                           region.centerLongitude != longitude ||
                           region.zoomLevel != zoomLevel
        
        if regionChanged {
            region.centerLatitude = latitude
            region.centerLongitude = longitude
            region.zoomLevel = zoomLevel
        }
    }
    
    func moveToLocation(_ location: CLLocationCoordinate2D) {
        updateRegion(
            latitude: location.latitude,
            longitude: location.longitude,
            zoomLevel: region.zoomLevel
        )
    }
    
    func changeZoomLevel(by delta: Int) {
        let newZoom = max(1, min(19, region.zoomLevel + delta))
        if newZoom != region.zoomLevel {
            updateRegion(
                latitude: region.centerLatitude,
                longitude: region.centerLongitude,
                zoomLevel: newZoom
            )
        }
    }
    
    func userDidInteract() {
        DispatchQueue.main.async { [weak self] in
            self?.isUIVisible = true
        }
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isUIVisible = false
            }
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
    
    deinit {
        clearCache()
    }
}
