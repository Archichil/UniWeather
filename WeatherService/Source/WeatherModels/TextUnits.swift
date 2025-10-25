public struct TextUnits: Sendable {
    public let windUnits: String
    public let tempUnits: String

    public init(windUnits: String, tempUnits: String) {
        self.windUnits = windUnits
        self.tempUnits = tempUnits
    }
}
