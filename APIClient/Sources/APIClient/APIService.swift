//
//  APIService.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

open class APIService {
    public var apiClient: APIClient?

    public init(apiClient: APIClient?) {
        self.apiClient = apiClient
    }
}
