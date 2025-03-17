//
//  APISpec.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import Foundation

extension APIClient {
    protocol APISpec {
        var endpoint: String { get }
        var method: HttpMethod { get }
        var returnType: DecodableType.Type { get }
        var headers: [String: String]? { get }
        var body: Data? { get }
    }
}
