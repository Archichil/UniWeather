public struct Coordinates: Decodable, Sendable, Equatable {
    public let lon: Double
    public let lat: Double

    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}
