public struct AirPollution: Decodable, Sendable {
    public let coord: Coordinates
    public let list: [AirPollutionData]
}
