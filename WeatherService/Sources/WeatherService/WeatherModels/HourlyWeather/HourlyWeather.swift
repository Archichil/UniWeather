public struct HourlyWeather: Decodable, Sendable {
    public let cod: String
    public let message: Int
    public let cnt: Int
    public let list: [WeatherData]
    public let city: City
}
