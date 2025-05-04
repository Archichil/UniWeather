import SwiftUI

struct AirQualityBarView: View {
    private let currentAQI: Double
    private let maxAQI: Double = 500

    /// Designated initializer with exact AQI value
    init(currentAQI: Double) {
        self.currentAQI = min(max(currentAQI, 0), maxAQI)
    }

    /// Convenience initializer with only group index (1...6)
    /// Places the marker at the midpoint of the corresponding AQI band.
    init(groupIndex: Int) {
        self.currentAQI = AirQualityBarView.midpoint(for: groupIndex)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: gradientStops()),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 7)

                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 1)
                        .frame(width: 8, height: 8)
                        .offset(x: markerOffset(in: proxy.size.width) - 6)
                }
            }
            .frame(height: 8)
        }
    }

    /// Defines linear-gradient stops at each AQI category boundary
    private func gradientStops() -> [Gradient.Stop] {
        let boundaries: [(value: Double, color: Color)] = [
            (0, Color.green),
            (50, Color.yellow),
            (100, Color.orange),
            (150, Color.red),
            (200, Color.purple),
            (300, Color(red: 0.5, green: 0.0, blue: 0.0)),
        ]

        return boundaries.map { stop in
            Gradient.Stop(color: stop.color, location: stop.value / maxAQI)
        }
    }

    /// Computes horizontal offset for the marker based on AQI fraction
    private func markerOffset(in width: CGFloat) -> CGFloat {
        let fraction = CGFloat(currentAQI / maxAQI)
        return width * fraction
    }

    /// Returns the midpoint AQI for a given health category index
    private static func midpoint(for groupIndex: Int) -> Double {
        let bands: [ClosedRange<Double>] = [
            0...50,
            50...100,
            100...150,
            150...200,
            200...300,
            300...500
        ]
        let idx = min(max(groupIndex - 1, 0), bands.count - 1)
        let range = bands[idx]
        return (range.lowerBound + range.upperBound) / 2
    }
    
    public static func getLevelDescription(aqi: Int) -> String {
        
        switch AirQualityBarView.midpoint(for: aqi) {
        case 0..<50:
            return "Очень низкое"
        case 50..<100:
            return "Низкое"
        case 100..<150:
            return "Умеренное"
        case 150..<200:
            return "Нездоровое"
        case 200..<300:
            return "Вредное"
        case 300...:
            return "Очень вредное"
        default:
            return ""
        }
    }
}

#Preview {
    AirQualityBarView(groupIndex: 3)
    AirQualityBarView(currentAQI: 250)
}
