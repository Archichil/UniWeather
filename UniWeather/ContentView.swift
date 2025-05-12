//
//  ContentView.swift
//  UniWeather
//
//  Created by Archichil on 14.03.25.
//

import SwiftUI
import WeatherService
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    @State private var coordinate: CLLocationCoordinate2D?
    
    private enum Constants {
        static let defaultCoordinates = Coordinates(lat: 53.893009, lon: 27.567444)
        static let waitingText = String(localized: "contentView.waitingText")
    }

    var body: some View {
        Group {
            if let coordinate {
                WeatherInfoView(viewModel: WeatherInfoViewModel(
                    coordinate: Coordinates(lat: coordinate.latitude, lon: coordinate.longitude)
                ))
            } else {
                ProgressView(Constants.waitingText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.blue)
            }
        }
        .task {
            if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                coordinate = CLLocationCoordinate2D(latitude: Constants.defaultCoordinates.lat, longitude: Constants.defaultCoordinates.lon)
            } else {
                let location = await locationManager.awaitLocation()
                coordinate = location.coordinate
            }
        }
    }
}
