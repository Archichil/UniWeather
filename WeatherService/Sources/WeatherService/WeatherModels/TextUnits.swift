//
//  TextUnits.swift
//  UniWeather
//
//  Created by Daniil on 24.03.25.
//

import APIClient

public struct TextUnits: Sendable {
    public let windUnits: String
    public let tempUnits: String
    
    public init(windUnits: String, tempUnits: String) {
        self.windUnits = windUnits
        self.tempUnits = tempUnits
    }
}
