//
//  HttpMethod.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

extension APIClient {
    /// An enumeration representing the HTTP methods supported by the API client.
    ///
    /// This enum defines the standard HTTP methods that can be used when making requests to an API.
    /// Each case corresponds to a specific HTTP method and its associated raw value.
    ///
    /// ## Example
    /// ```swift
    /// let method = APIClient.HttpMethod.post
    /// print(method.rawValue) // Output: "POST"
    /// ```
    public enum HttpMethod: String, CaseIterable {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
    }
}
