//
//  MapRegion.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import WeatherService

public struct MapRegion {
    public var centerLatitude: Double
    public var centerLongitude: Double
    public var zoomLevel: Int

    public init(latitude: Double = WeatherMapConfiguration.defaultLatitude,
                longitude: Double = WeatherMapConfiguration.defaultLongitude,
                zoomLevel: Int = WeatherMapConfiguration.defaultZoomLevel)
    {
        centerLatitude = latitude
        centerLongitude = longitude
        self.zoomLevel = zoomLevel
    }
}
