//
//  DecodableType.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

/// A protocol that marks a type as decodable from JSON data.
///
/// This protocol is used to ensure that types can be decoded from JSON responses
/// returned by the API. It is a refinement of the `Decodable` protocol.
///
/// ## Example
/// ```swift
/// struct MyResponse: DecodableType {
///     let id: Int
///     let name: String
/// }
/// ```
public protocol DecodableType: Decodable {}

/// Extends `Array` to conform to `DecodableType` when its elements conform to `DecodableType`.
///
/// This allows arrays of decodable types to be used as return types in API specifications.
///
/// ## Example
/// ```swift
/// struct MyResponse: DecodableType {
///     let id: Int
///     let name: String
/// }
///
/// let response: [MyResponse] = try decoder.decode([MyResponse].self, from: data)
/// ```
extension Array: DecodableType where Element: DecodableType {}
