//
//  MapRegion.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

struct MapRegion {
    var centerLatitude: Double
    var centerLongitude: Double
    var zoomLevel: Int

    init(latitude: Double = WeatherMapConfiguration.defaultLatitude,
         longitude: Double = WeatherMapConfiguration.defaultLongitude,
         zoomLevel: Int = WeatherMapConfiguration.defaultZoomLevel)
    {
        centerLatitude = latitude
        centerLongitude = longitude
        self.zoomLevel = zoomLevel
    }
}
