//
//  ContentView.swift
//  UniWeather
//
//  Created by Archichil on 14.03.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                let baseURL = URL(string: "")
                let apiClient = APIClient(baseURL: baseURL!)

                let currentWeatherAPIService = CurrentWeatherAPIService(apiClient: apiClient)
                do {
                    let weather = try await currentWeatherAPIService.getCurrentWeather(
                        coords: Coordinates(lat: 53.9, lon: 27.56),
                        appId: ""
//                        ,units: Units.metric
//                        ,lang: Language.ru
                    )
                     print(weather ?? "nil")
                } catch {
                    print(#function, error)
                }
            }

        }
    }
}

#Preview {
    ContentView()
}
