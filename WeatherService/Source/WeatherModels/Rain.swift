public struct Rain: Decodable, Sendable {
    public let oneHour: Double?

    public enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
