//
//  ContentView.swift
//  UniWeatherWatch Watch App
//
//  Created by Daniil on 13.05.25.
//

import SwiftUI
import WeatherService

struct ContentView: View {
    @StateObject private var sessionManager = SessionManager.shared
    @State private var showLocationSelector = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if let coords = sessionManager.lastLocation {
                    MainTabView(viewModel: WeatherInfoViewModel(coordinate: coords))
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    showLocationSelector = true
                                } label: {
                                    Image(systemName: "line.3.horizontal")
                                        .font(.system(size: 20))
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .fill(.thinMaterial)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                } else {
                    SelectLocationView()
                        .navigationBarHidden(true)
                }
            }
            .navigationDestination(isPresented: $showLocationSelector) {
                SelectLocationView()
            }
        }
    }
}



#Preview {
    ContentView()
}
