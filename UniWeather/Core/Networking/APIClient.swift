//
//  APIClient.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

struct APIClient {
    private var baseURL: URL
    private var urlSession: URLSession
    
    init(
        baseURL: URL,
        urlSession: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
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


    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
}

