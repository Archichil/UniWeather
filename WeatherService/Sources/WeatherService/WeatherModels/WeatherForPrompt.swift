public struct WeatherForPrompt {
    public let temperature: Double
    public let feelsLike: Double
    public let tempMin: Double
    public let tempMax: Double
    public let humidity: Int
    public let windSpeed: Double
    public let cloudiness: Int
    public let precipitation: Double
    public let weatherDescription: String

    public init(temperature: Double, feelsLike: Double, tempMin: Double, tempMax: Double, humidity: Int, windSpeed: Double, cloudiness: Int, precipitation: Double, weatherDescription: String) {
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.cloudiness = cloudiness
        self.precipitation = precipitation
        self.weatherDescription = weatherDescription
    }
}
