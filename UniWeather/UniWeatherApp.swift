//
//  UniWeatherApp.swift
//  UniWeather
//
//  Created by Archichil on 14.03.25.
//

import SwiftUI

@main
struct UniWeatherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [LocationEntity.self])
    }
}
