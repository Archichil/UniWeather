public struct City: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let coord: Coordinates
    public let country: String
    public let timezone: Int
    public let sunrise: Int?
    public let sunset: Int?
    public let population: Int
}
