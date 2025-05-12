//
//  WeatherMapConfiguration.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 24.03.25.
//

import APIClient
import Foundation
import SwiftUI

public enum WeatherMapConfiguration {
    public static let defaultZoomLevel = 5
    public static let defaultLatitude = 53.902284
    public static let defaultLongitude = 27.561831

    // Available map layer types for Weather Map 2.0
    public enum MapLayer: String, CaseIterable, Identifiable {
        // New layer types for Weather Map 2.0
        case convectivePrecipitation = "PAC0"
        case precipitationIntensity = "PR0"
        case accumulatedPrecipitation = "PA0"
        case accumulatedPrecipitationRain = "PAR0"
        case accumulatedPrecipitationSnow = "PAS0"
        case snowDepth = "SD0"
        case windSpeedTenMetersAltitude = "WS10"
        case wind = "WND"
        case atmosphericPressureSeaLevel = "APM"
        case airTemperatureTwoMetersAltitude = "TA2"
        case dewPointTemperature = "TD2"
        case soilTemperatureZeroDepth = "TS0" // Kelvins
        case soilTemperatureTenCmDepth = "TS10"
        case relativeHumidity = "HRD0"
        case clouds = "CL"

        public var id: String { rawValue }

        public var displayName: String {
            switch self {
            case .convectivePrecipitation: String(localized: "weatherMapConfiguration.mapLayer.convectivePrecipitation.displayName")
            case .precipitationIntensity: String(localized: "weatherMapConfiguration.mapLayer.precipitationIntensity.displayName")
            case .accumulatedPrecipitation: String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitation.displayName")
            case .accumulatedPrecipitationRain: String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitationRain.displayName")
            case .accumulatedPrecipitationSnow: String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitationSnow.displayName")
            case .snowDepth: String(localized: "weatherMapConfiguration.mapLayer.snowDepth.displayName")
            case .windSpeedTenMetersAltitude: String(localized: "weatherMapConfiguration.mapLayer.windSpeedTenMetersAltitude.displayName")
            case .wind: String(localized: "weatherMapConfiguration.mapLayer.wind.displayName")
            case .atmosphericPressureSeaLevel: String(localized: "weatherMapConfiguration.mapLayer.atmosphericPressureSeaLevel.displayName")
            case .airTemperatureTwoMetersAltitude: String(localized: "weatherMapConfiguration.mapLayer.airTemperatureTwoMetersAltitude.displayName")
            case .dewPointTemperature: String(localized: "weatherMapConfiguration.mapLayer.dewPointTemperature.displayName")
            case .soilTemperatureZeroDepth: String(localized: "weatherMapConfiguration.mapLayer.soilTemperatureZeroDepth.displayName")
            case .soilTemperatureTenCmDepth: String(localized: "weatherMapConfiguration.mapLayer.soilTemperatureTenCmDepth.displayName")
            case .relativeHumidity: String(localized: "weatherMapConfiguration.mapLayer.relativeHumidity.displayName")
            case .clouds: String(localized: "weatherMapConfiguration.mapLayer.clouds.displayName")
            }
        }

        public var displayIcon: String {
            switch self {
            case .convectivePrecipitation: "cloud.bolt.rain"
            case .precipitationIntensity: "cloud.rain"
            case .accumulatedPrecipitation: "drop.fill"
            case .accumulatedPrecipitationRain: "cloud.rain.fill"
            case .accumulatedPrecipitationSnow: "cloud.snow.fill"
            case .snowDepth: "snow"
            case .windSpeedTenMetersAltitude: "wind"
            case .wind: "wind.circle"
            case .atmosphericPressureSeaLevel: "gauge"
            case .airTemperatureTwoMetersAltitude: "thermometer"
            case .dewPointTemperature: "humidity"
            case .soilTemperatureZeroDepth: "thermometer.low"
            case .soilTemperatureTenCmDepth: "arrow.down.to.line.compact"
            case .relativeHumidity: "humidity.fill"
            case .clouds: "cloud.fill"
            }
        }

        public var measurementValue: String {
            switch self {
            case .convectivePrecipitation:
                String(localized: "weatherMapConfiguration.mapLayer.convectivePrecipitation.measurementValue")
            case .precipitationIntensity:
                String(localized: "weatherMapConfiguration.mapLayer.precipitationIntensity.measurementValue")
            case .accumulatedPrecipitation:
                String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitation.measurementValue")
            case .accumulatedPrecipitationRain:
                String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitationRain.measurementValue")
            case .accumulatedPrecipitationSnow:
                String(localized: "weatherMapConfiguration.mapLayer.accumulatedPrecipitationSnow.measurementValue")
            case .snowDepth:
                String(localized: "weatherMapConfiguration.mapLayer.snowDepth.measurementValue")
            case .windSpeedTenMetersAltitude:
                String(localized: "weatherMapConfiguration.mapLayer.windSpeedTenMetersAltitude.measurementValue")
            case .wind:
                String(localized: "weatherMapConfiguration.mapLayer.wind.measurementValue")
            case .atmosphericPressureSeaLevel:
                String(localized: "weatherMapConfiguration.mapLayer.atmosphericPressureSeaLevel.measurementValue")
            case .airTemperatureTwoMetersAltitude:
                String(localized: "weatherMapConfiguration.mapLayer.airTemperatureTwoMetersAltitude.measurementValue")
            case .dewPointTemperature:
                String(localized: "weatherMapConfiguration.mapLayer.dewPointTemperature.measurementValue")
            case .soilTemperatureZeroDepth:
                String(localized: "weatherMapConfiguration.mapLayer.soilTemperatureZeroDepth.measurementValue")
            case .soilTemperatureTenCmDepth:
                String(localized: "weatherMapConfiguration.mapLayer.soilTemperatureTenCmDepth.measurementValue")
            case .relativeHumidity:
                String(localized: "weatherMapConfiguration.mapLayer.relativeHumidity.measurementValue")
            case .clouds:
                String(localized: "weatherMapConfiguration.mapLayer.clouds.measurementValue")
            }
        }

        public var colorLevels: [(key: String, value: Color)] {
            switch self {
            case .convectivePrecipitation:
                [
                    ("1", Color(hex: "ACAAF7")),
                    ("10", Color(hex: "8D8AF3")),
                    ("20", Color(hex: "706EC2")),
                    ("40", Color(hex: "5658FF")),
                    ("100", Color(hex: "5B5DB1")),
                    ("200", Color(hex: "3E3F85")),
                ]
            case .precipitationIntensity:
                [
                    ("0.000005", Color(hex: "FEF9CA")),
                    ("0.000014", Color(hex: "93F57D")),
                    ("0.000046", Color(hex: "50B033")),
                    ("0.000231", Color(hex: "204E11")),
                    ("0.000694", Color(hex: "E96F2D")),
                    ("0.001388", Color(hex: "B02318")),
                    ("0.023150", Color(hex: "090A08")),
                ]
            case .accumulatedPrecipitation:
                [
                    ("0", Color(hex: "00000000")),
                    ("0.1", Color(hex: "C8969600")),
                    ("0.2", Color(hex: "9696AA00")),
                    ("0.5", Color(hex: "7878BE19")),
                    ("1", Color(hex: "6E6ECD33")),
                    ("10", Color(hex: "5050E1B2")),
                    ("140", Color(hex: "1414FFE5")),
                ]
            case .accumulatedPrecipitationRain:
                [
                    ("0", Color(hex: "E1C86400")),
                    ("0.1", Color(hex: "C8963200")),
                    ("0.2", Color(hex: "9696AA00")),
                    ("0.5", Color(hex: "7878BE00")),
                    ("1", Color(hex: "6E6ECD4C")),
                    ("10", Color(hex: "5050E1B2")),
                    ("140", Color(hex: "1414FFE5")),
                ]
            case .accumulatedPrecipitationSnow:
                [
                    ("0", Color(hex: "00000000")),
                    ("5", Color(hex: "00D8FFFF")),
                    ("10", Color(hex: "00B6FFFF")),
                    ("25.076", Color(hex: "9549FF")),
                ]
            case .snowDepth:
                [
                    ("0.05", Color(hex: "EDEDED")),
                    ("0.2", Color(hex: "A5E5EF")),
                    ("0.6", Color(hex: "706DCE")),
                    ("1.2", Color(hex: "C454B7")),
                    ("3.0", Color(hex: "7F2389")),
                    ("4.0", Color(hex: "790087")),
                    ("15", Color(hex: "E80068")),
                ]
            case .windSpeedTenMetersAltitude:
                [
                    ("1", Color(hex: "FFFFFF00")),
                    ("5", Color(hex: "EECECC66")),
                    ("15", Color(hex: "B364BCB3")),
                    ("25", Color(hex: "3F213BCC")),
                    ("50", Color(hex: "744CACE6")),
                    ("100", Color(hex: "4600AFFF")),
                    ("200", Color(hex: "0D1126FF")),
                ]
            case .wind:
                [
                    ("1", Color(hex: "FFFFFF00")),
                    ("5", Color(hex: "EECECC66")),
                    ("15", Color(hex: "B364BCB3")),
                    ("25", Color(hex: "3F213BCC")),
                    ("50", Color(hex: "744CACE6")),
                    ("100", Color(hex: "4600AFFF")),
                    ("200", Color(hex: "0D1126FF")),
                ]
            case .atmosphericPressureSeaLevel:
                [
                    ("94000", Color(hex: "0073FF")),
                    ("98000", Color(hex: "4BD0D6")),
                    ("101000", Color(hex: "B0F720")),
                    ("104000", Color(hex: "FB5515")),
                    ("108000", Color(hex: "C60000")),
                ]
            case .airTemperatureTwoMetersAltitude:
                [
                    ("-55", Color(hex: "821692")),
                    ("-40", Color(hex: "821692")),
                    ("-30", Color(hex: "8257DB")),
                    ("-10", Color(hex: "20C4E8")),
                    ("0", Color(hex: "23DDDD")),
                    ("20", Color(hex: "FFF028")),
                    ("25", Color(hex: "FFC228")),
                    ("30", Color(hex: "FC8014")),
                ]
            case .dewPointTemperature:
                [
                    ("-65", Color(hex: "821692")),
                    ("-45", Color(hex: "821692")),
                    ("-30", Color(hex: "8257DB")),
                    ("-10", Color(hex: "20C4E8")),
                    ("0", Color(hex: "23DDDD")),
                    ("10", Color(hex: "C2FF28")),
                    ("20", Color(hex: "FFF028")),
                    ("25", Color(hex: "FFC228")),
                    ("30", Color(hex: "FC8014")),
                ]
            case .soilTemperatureZeroDepth:
                [
                    ("203.15", Color(hex: "491763")),
                    ("235.15", Color(hex: "514F9B")),
                    ("251.15", Color(hex: "88A7C9")),
                    ("267.15", Color(hex: "A7D5AD")),
                    ("283.15", Color(hex: "F2B68A")),
                    ("291.15", Color(hex: "EB702D")),
                    ("303.15", Color(hex: "CC2C44")),
                    ("323.15", Color(hex: "990000")),
                ]
            case .soilTemperatureTenCmDepth:
                [
                    ("203.15", Color(hex: "491763")),
                    ("235.15", Color(hex: "514F9B")),
                    ("251.15", Color(hex: "88A7C9")),
                    ("267.15", Color(hex: "A7D5AD")),
                    ("283.15", Color(hex: "F2B68A")),
                    ("291.15", Color(hex: "EB702D")),
                    ("303.15", Color(hex: "CC2C44")),
                    ("323.15", Color(hex: "990000")),
                ]
            case .relativeHumidity:
                [
                    ("0", Color(hex: "DB1200")),
                    ("20", Color(hex: "965700")),
                    ("40", Color(hex: "EDE100")),
                    ("60", Color(hex: "8BD600")),
                    ("80", Color(hex: "00A808")),
                    ("100", Color(hex: "000099")),
                ]
            case .clouds:
                [
                    ("0", Color(hex: "FFFFFF00")),
                    ("20", Color(hex: "FCFBFF26")),
                    ("40", Color(hex: "F9F8FF4C")),
                    ("60", Color(hex: "F6F5FF8C")),
                    ("80", Color(hex: "E9E9DFCC")),
                    ("100", Color(hex: "D2D2D2FF")),
                ]
            }
        }
    }
}
