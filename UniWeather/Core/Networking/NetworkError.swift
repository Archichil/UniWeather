//
//  NetworkError.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case dataConversionFailure
}
