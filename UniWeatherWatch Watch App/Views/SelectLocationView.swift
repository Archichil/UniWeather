//
//  SelectLocationView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI
import WeatherService

struct SelectLocationView: View {
    @StateObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                if let location = sessionManager.lastLocation {
                    LocationItemView(place: sessionManager.lastPlace, coordinate: Coordinates(lat: location.lat, lon: location.lon), isCurrentLocation: true)
                }
                ForEach(sessionManager.savedLocations) { item in
                    LocationItemView(place: item.cityName ?? "Неизвестно",coordinate: Coordinates(lat: item.latitude, lon: item.longitude), isCurrentLocation: false)
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

private struct LocationItemView: View {
    let isCurrentLocation: Bool
    let coordinate: Coordinates
    @StateObject private var viewModel: WeatherInfoViewModel
    @State private var currentTime = Date()
    
    init(place: String, coordinate: Coordinates, isCurrentLocation: Bool) {
        self.coordinate = coordinate
        self.isCurrentLocation = isCurrentLocation
        _viewModel = StateObject(wrappedValue: WeatherInfoViewModel(place: place ,coordinate: coordinate))
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: viewModel.currentWeather?.timezone ?? 0)
        return formatter.string(from: currentTime)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoaded {
                NavigationLink {
                    MainTabView(viewModel: viewModel, isCurrentLocation: isCurrentLocation)
                } label: {
                    VStack(spacing: 0) {
                        HStack {
                            Text(viewModel.currentPlace ?? "Неизвестно")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if (isCurrentLocation) {
                                Image(systemName: "location.fill")
                            }
                        }
                        .font(.caption2)
                        
                        
                        Text("\(Int(viewModel.currentWeather?.main.temp.rounded() ?? -99))º")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(timeString)
                            .font(.caption2)
                            .foregroundStyle(secondaryColor)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 90)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .background(backgroundGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(.plain)
                
            } else {
                skeletonView
            }
        }
        .animation(.smooth(duration: 0.5), value: viewModel.isLoaded)
        .onAppear {
            guard !viewModel.isLoaded else { return }
            Task {
                await viewModel.loadAllWeather(loadGeo: false)
            }
        }
        .onReceive(
            Timer.publish(every: 10, on: .main, in: .common).autoconnect()
        ) { _ in
            currentTime = Date()
        }
        .onReceive(
            Timer.publish(every: 3600, on: .main, in: .common).autoconnect()
        ) { _ in
            Task {
                await viewModel.loadAllWeather(loadGeo: false)
            }
        }
        
    }
    
    private var skeletonView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("ТЕКСТ ТЕКСТ ТЕКСТ")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption2)
            
            
            Text("---")
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("ТАЙМ НАУ")
                .font(.caption2)
                .foregroundStyle(secondaryColor)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .redacted(reason: .placeholder)
        .background(getBackgroundGradient(weatherCode: "01d", dt: 10000, sunset: 20000, sunrise: 0))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
//
//#Preview {
//    SelectLocationView()
//}
