//
//  WeatherMapRenderer.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import SwiftUI
import MapKit

struct WeatherMapRenderer: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        configureMapAppearance(mapView)
        
        let initialCoordinate = CLLocationCoordinate2D(
            latitude: viewModel.region.centerLatitude,
            longitude: viewModel.region.centerLongitude
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: 180 / pow(2.0, Double(viewModel.region.zoomLevel)) * 2,
            longitudeDelta: 360 / pow(2.0, Double(viewModel.region.zoomLevel)) * 2
        )
        
        mapView.setRegion(MKCoordinateRegion(center: initialCoordinate, span: span), animated: false)
        
        if let overlay = viewModel.currentTileOverlay {
            mapView.addOverlay(overlay, level: .aboveRoads)
        }
        
        return mapView
    }
    
    private func configureMapAppearance(_ mapView: MKMapView) {
        mapView.pointOfInterestFilter = .includingAll
        mapView.showsBuildings = false
        mapView.showsTraffic = false
        mapView.showsUserLocation = true
        
        if #available(iOS 16.0, *) {
            let configuration = MKStandardMapConfiguration()
            configuration.pointOfInterestFilter = .excludingAll
            configuration.showsTraffic = false
            mapView.preferredConfiguration = configuration
        }
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
            mapView.addOverlay(newOverlay, level: .aboveRoads)
        }
    }
 
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var lastSelectedLayer: WeatherMapConfiguration.MapLayer?
        var lastSelectedDate: Date?
        var parent: WeatherMapRenderer
        private var regionChangeDebounceTimer: Timer?
        
        init(_ parent: WeatherMapRenderer) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? WeatherTileOverlay {
                let renderer = MKTileOverlayRenderer(tileOverlay: tileOverlay)
                renderer.alpha = 1.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.viewModel.userDidInteract()
            regionChangeDebounceTimer?.invalidate()
            
            regionChangeDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                
                let center = mapView.centerCoordinate
                let span = mapView.region.span
                let newZoomLevel = Int(log2(360 / span.longitudeDelta))
                
                let hasSignificantChange = abs(center.latitude - self.parent.viewModel.region.centerLatitude) > 0.01 ||
                                           abs(center.longitude - self.parent.viewModel.region.centerLongitude) > 0.01 ||
                                           newZoomLevel != self.parent.viewModel.region.zoomLevel

                if hasSignificantChange {
                    DispatchQueue.main.async {
                        self.parent.viewModel.updateRegion(
                            latitude: center.latitude,
                            longitude: center.longitude,
                            zoomLevel: max(1, min(19, newZoomLevel))
                        )
                    }
                }
            }
        }
    }
}
