//
//  APISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

extension APIClient {
    /// A protocol that defines the specification for an API request.
    ///
    /// Conforming types provide the necessary details to construct a URL request,
    /// including the endpoint, HTTP method, headers, body, and expected return type.
    ///
    /// ## Example
    /// ```swift
    /// struct MyAPISpec: APIClient.APISpec {
    ///     var endpoint: String { "/my-endpoint" }
    ///     var method: HttpMethod { .get }
    ///     var returnType: DecodableType.Type { MyResponseType.self }
    ///     var headers: [String: String]? { ["Authorization": "Bearer token"] }
    ///     var body: Data? { nil }
    /// }
    /// ```
    public protocol APISpec {
        /// The API endpoint for the request.
        ///
        /// This is the path that will be appended to the base URL of the ``APIClient``.
        var endpoint: String { get }

        /// The HTTP method for the request.
        var method: HttpMethod { get }

        /// The expected return type for the response.
        ///
        /// This type must conform to `Decodable` and will be used to decode the response data.
        var returnType: DecodableType.Type { get }

        /// The headers to include in the request.
        ///
        /// This is an optional dictionary of header fields and their values.
        var headers: [String: String]? { get }

        /// The body of the request.
        ///
        /// This is an optional `Data` object that will be sent as the HTTP body.
        var body: Data? { get }
    }
}
