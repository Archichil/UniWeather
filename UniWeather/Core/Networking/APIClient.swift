//
//  APIClient.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

/// A client for making network requests to an API.
///
/// This struct provides methods to send requests to an API and handle responses.
/// It supports decoding responses into `Decodable` types and handles common network errors.
///
/// ## Example
/// ```swift
/// let baseURL = URL(string: "https://api.example.com")!
/// let apiClient = APIClient(baseURL: baseURL)
///
/// Task {
///     do {
///         let response = try await apiClient.sendRequest(someAPISpec)
///         print(response)
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
struct APIClient {
    /// The base URL for the API.
    private var baseURL: URL

    /// The URL session used to perform network requests.
    private var urlSession: URLSession

    /// Initializes a new `APIClient` instance.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the API.
    ///   - urlSession: The URL session to use for network requests. Defaults to `URLSession.shared`.
    init(
        baseURL: URL,
        urlSession: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    /// Sends a request to the API based on the provided specification.
    ///
    /// This method constructs a URL request from the `APISpec`, sends it, and decodes the response into the specified `Decodable` type.
    ///
    /// - Parameter apiSpec: The API specification that defines the request to be sent.
    /// - Returns: A decoded response of type `DecodableType`.
    /// - Throws: An error if the request fails, the response is invalid, or decoding fails.
    ///
    /// ## Example
    /// ```swift
    /// let response = try await apiClient.sendRequest(someAPISpec)
    /// ```
    func sendRequest(_ apiSpec: APISpec) async throws -> DecodableType {
        guard let url = URL(string: baseURL.absoluteString + apiSpec.endpoint) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: TimeInterval(floatLiteral: 30.0)
        )
        request.httpMethod = apiSpec.method.rawValue
        request.httpBody = apiSpec.body
        request.allHTTPHeaderFields = apiSpec.headers

        var responseData: Data? = nil
        do {
            let (data, response) = try await urlSession.data(for: request)
            try handleResponse(data: data, response: response)
            responseData = data
        } catch {
            throw error
        }

        // Don't have to decode data if it's raw data
        if apiSpec.returnType == Data.self {
            return responseData ?? Data()
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let decodedData = try decoder.decode(
                apiSpec.returnType,
                from: responseData!
            )
            return decodedData
        } catch let error as DecodingError {
            throw error
        } catch {
            throw NetworkError.dataConversionFailure
        }
    }

    /// Validates the HTTP response from the API.
    ///
    /// This method checks if the response is a valid `HTTPURLResponse` and if the status code is within the success range (200-299).
    ///
    /// - Parameters:
    ///   - data: The data returned by the API.
    ///   - response: The URL response returned by the API.
    /// - Throws: An error if the response is invalid or the status code indicates a failure.
    private func handleResponse(data _: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
}
