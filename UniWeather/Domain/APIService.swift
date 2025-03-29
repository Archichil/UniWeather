//
//  APIService.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

class APIService {
    var apiClient: APIClient?

    init(apiClient: APIClient?) {
        self.apiClient = apiClient
    }
}
