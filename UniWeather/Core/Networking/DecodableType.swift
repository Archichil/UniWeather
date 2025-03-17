//
//  DecodableType.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

protocol DecodableType: Decodable { }
// Make Array of DecodableType also conform to DecodableType if needed.
// For cases where the API returns an array of entities.
extension Array: DecodableType where Element: DecodableType { }
