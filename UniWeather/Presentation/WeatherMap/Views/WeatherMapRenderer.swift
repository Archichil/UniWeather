//
//  WeatherMapRenderer.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import MapKit
import SwiftUI
import WeatherMapService

struct WeatherMapRenderer: UIViewRepresentable {
    // MARK: - Constants

    private enum Constants {
        enum Map {
            static let initialSpanMultiplier: Double = 2.0
            static let earthCircumference: Double = 360
            static let minZoomLevel: Int = 1
            static let maxZoomLevel: Int = 19
            static let tileSize = CGSize(width: 256, height: 256)
            static let overlayLevel: MKOverlayLevel = .aboveRoads
            static let rendererAlpha: CGFloat = 1.0
        }

        enum Region {
            static let significantChangeThreshold: Double = 0.01
            static let debounceInterval: TimeInterval = 0.5
        }

        enum Appearance {
            static let showsBuildings = false
            static let showsTraffic = false
            static let showsUserLocation = true
            static let pointOfInterestFilter: MKPointOfInterestFilter = .includingAll
        }
    }

    // MARK: - Properties

    @ObservedObject var viewModel: MapViewModel

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        configureMapAppearance(mapView)
        setupInitialRegion(mapView: mapView)
        addInitialOverlay(to: mapView)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        guard let newOverlay = viewModel.currentTileOverlay else { return }

        if viewModel.date != context.coordinator.lastSelectedDate {
            mapView.removeOverlays(mapView.overlays)
            context.coordinator.lastSelectedDate = viewModel.date
        }

        if viewModel.selectedLayer != context.coordinator.lastSelectedLayer {
            mapView.removeOverlays(mapView.overlays)
            context.coordinator.lastSelectedLayer = viewModel.selectedLayer
        }

        if !mapView.overlays.contains(where: { $0 as? WeatherTileOverlay === newOverlay }) {
            mapView.addOverlay(newOverlay, level: Constants.Map.overlayLevel)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Private Methods

    private func configureMapAppearance(_ mapView: MKMapView) {
        mapView.pointOfInterestFilter = Constants.Appearance.pointOfInterestFilter
        mapView.showsBuildings = Constants.Appearance.showsBuildings
        mapView.showsTraffic = Constants.Appearance.showsTraffic
        mapView.showsUserLocation = Constants.Appearance.showsUserLocation

        if #available(iOS 16.0, *) {
            let configuration = MKStandardMapConfiguration()
            configuration.pointOfInterestFilter = .excludingAll
            configuration.showsTraffic = false
            mapView.preferredConfiguration = configuration
        }
    }

    private func setupInitialRegion(mapView: MKMapView) {
        let initialCoordinate = CLLocationCoordinate2D(
            latitude: viewModel.region.centerLatitude,
            longitude: viewModel.region.centerLongitude
        )

        let span = MKCoordinateSpan(
            latitudeDelta: Constants.Map.earthCircumference / pow(2.0, Double(viewModel.region.zoomLevel)) * Constants.Map.initialSpanMultiplier,
            longitudeDelta: Constants.Map.earthCircumference / pow(2.0, Double(viewModel.region.zoomLevel)) * Constants.Map.initialSpanMultiplier
        )

        mapView.setRegion(MKCoordinateRegion(center: initialCoordinate, span: span), animated: false)
    }

    private func addInitialOverlay(to mapView: MKMapView) {
        if let overlay = viewModel.currentTileOverlay {
            mapView.addOverlay(overlay, level: Constants.Map.overlayLevel)
        }
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, MKMapViewDelegate {
        var lastSelectedLayer: WeatherMapConfiguration.MapLayer?
        var lastSelectedDate: Date?
        var parent: WeatherMapRenderer
        private var regionChangeDebounceTimer: Timer?

        init(_ parent: WeatherMapRenderer) {
            self.parent = parent
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? WeatherTileOverlay {
                let renderer = MKTileOverlayRenderer(tileOverlay: tileOverlay)
                renderer.alpha = Constants.Map.rendererAlpha
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated _: Bool) {
            parent.viewModel.userDidInteract()
            regionChangeDebounceTimer?.invalidate()

            regionChangeDebounceTimer = Timer.scheduledTimer(
                withTimeInterval: Constants.Region.debounceInterval,
                repeats: false
            ) { [weak self] _ in
                self?.handleRegionChange(mapView: mapView)
            }
        }

        private func handleRegionChange(mapView: MKMapView) {
            let center = mapView.centerCoordinate
            let span = mapView.region.span
            let newZoomLevel = Int(log2(Constants.Map.earthCircumference / span.longitudeDelta))

            let hasSignificantChange = abs(center.latitude - parent.viewModel.region.centerLatitude) > Constants.Region.significantChangeThreshold ||
                abs(center.longitude - parent.viewModel.region.centerLongitude) > Constants.Region.significantChangeThreshold ||
                newZoomLevel != parent.viewModel.region.zoomLevel

            if hasSignificantChange {
                DispatchQueue.main.async { [weak self] in
                    self?.parent.viewModel.updateRegion(
                        latitude: center.latitude,
                        longitude: center.longitude,
                        zoomLevel: max(Constants.Map.minZoomLevel, min(Constants.Map.maxZoomLevel, newZoomLevel))
                    )
                }
            }
        }
    }
}
