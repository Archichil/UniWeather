//
//  HttpMethod.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

extension APIClient {
    enum HttpMethod: String, CaseIterable {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
    }
}
