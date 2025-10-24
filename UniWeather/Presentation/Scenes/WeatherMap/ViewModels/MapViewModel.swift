//
//  MapViewModel.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 23.03.25.
//

import Foundation
import WeatherMapService

class MapViewModel: ObservableObject {
    // MARK: - Constants

    private enum Constants {
        enum Time {
            static let timeStep: TimeInterval = 3 * 3600
            static let maxTimeRange: TimeInterval = 24 * 3600
            static let uiHideDelay: TimeInterval = 3.0
        }

        enum Cache {
            static let countLimit = 1000
        }

        enum Zoom {
            static let minLevel = 1
            static let maxLevel = 19
        }

        enum Region {
            static let significantChangeThreshold = 0.01 // degrees
        }
    }

    // MARK: - Published Properties

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
    @Published private(set) var date: Date = .now.roundedToNearestHour() {
        didSet {
            currentTileOverlay = createTileOverlay()
            updateButtonsState()
        }
    }

    @Published var currentTileOverlay: WeatherTileOverlay? {
        didSet {
            if let oldValue, oldValue.layer != selectedLayer {
                oldValue.clearCache()
            }
        }
    }

    @Published var isUIVisible: Bool = true

    // MARK: - Private Properties

    private let initialDate: Date
    private var hideTimer: Timer?
    private var cache = NSCache<NSString, NSData>()

    // MARK: - Initialization

    init() {
        initialDate = Date.now.roundedToNearestHour()
        currentTileOverlay = createTileOverlay()
        updateButtonsState()
        cache.countLimit = Constants.Cache.countLimit
    }

    // MARK: - Private Methods

    private func updateButtonsState() {
        let pastDate = date.addingTimeInterval(-Constants.Time.timeStep)
        isBackwardDisabled = pastDate.timeIntervalSince(initialDate) < 0

        let futureDate = date.addingTimeInterval(Constants.Time.timeStep)
        isForwardDisabled = futureDate.timeIntervalSince(initialDate) > Constants.Time.maxTimeRange
    }

    private func createTileOverlay() -> WeatherTileOverlay {
        let overlay = WeatherTileOverlay(layer: selectedLayer, date: date)
        overlay.setCache(cache)
        return overlay
    }

    // MARK: - Public Methods

    func stepForward() {
        userDidInteract()
        let newDate = date.addingTimeInterval(Constants.Time.timeStep)
        if newDate.timeIntervalSince(initialDate) <= Constants.Time.maxTimeRange {
            date = newDate
        }
    }

    func stepBackward() {
        userDidInteract()
        let newDate = date.addingTimeInterval(-Constants.Time.timeStep)
        if newDate.timeIntervalSince(initialDate) >= 0 {
            date = newDate
        }
    }

    func updateRegion(latitude: Double, longitude: Double, zoomLevel: Int) {
        let regionChanged = abs(region.centerLatitude - latitude) > Constants.Region.significantChangeThreshold ||
            abs(region.centerLongitude - longitude) > Constants.Region.significantChangeThreshold ||
            region.zoomLevel != zoomLevel

        if regionChanged {
            region.centerLatitude = latitude
            region.centerLongitude = longitude
            region.zoomLevel = zoomLevel
        }
    }

    func changeZoomLevel(by delta: Int) {
        let newZoom = max(Constants.Zoom.minLevel, min(Constants.Zoom.maxLevel, region.zoomLevel + delta))
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
        hideTimer = Timer.scheduledTimer(
            withTimeInterval: Constants.Time.uiHideDelay,
            repeats: false
        ) { [weak self] _ in
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
