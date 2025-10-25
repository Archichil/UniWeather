public struct AirPollutionData: Decodable, Sendable {
    public let main: MainAQI
    public let components: AirComponents
    public let dt: Int
}
