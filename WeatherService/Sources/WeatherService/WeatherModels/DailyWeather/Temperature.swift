public struct Temperature: Decodable, Sendable {
    public let day: Double
    public let min: Double
    public let max: Double
    public let night: Double
    public let eve: Double
    public let morn: Double
}
