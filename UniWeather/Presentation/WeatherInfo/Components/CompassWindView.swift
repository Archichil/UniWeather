//
//  CompassWindView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI

struct CompassWindView: View {
    /// Wind direction in degrees (0 = North, 90 = East)
    var direction: Double
    
    /// Optional wind speed to display in center
    var speed: Double? = nil
    var unit: String = "км/ч"

    private let cardinalLabels = ["В", "Ю", "З", "С"]

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                // Outer ticks
                Circle()
                    .stroke(lineWidth: 1)
                    .foregroundColor(.secondary)
                    .frame(width: size, height: size)

                // Degree markers
                ForEach(0..<60) { tick in
                    let tickAngle = Angle(degrees: Double(tick) * 6)
                    if tick % 15 != 0 {
                        Rectangle()
                            .fill(Color.primary.opacity(0.3))
                            .frame(width: 1,
                                   height: tick % 5 == 0 ? 10 : 5)
                            .offset(y: -size / 2)
                            .rotationEffect(tickAngle)
                    }
                }

                ForEach(0..<4) { idx in
                    Text(cardinalLabels[idx])
                        .font(.headline)
                        .foregroundColor(.primary)
                        .position(
                            x: geo.size.width / 2 + CGFloat(cos(Double(idx) * .pi / 2) ) * (size / 2),
                            y: geo.size.height / 2 + CGFloat(sin(Double(idx) * .pi / 2) ) * (size / 2)
                        )
                }
                Arrow()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .frame(width: size * 0.6, height: size * 0.8)
                    .rotationEffect(Angle(degrees: direction))

                if let speed = speed {
                    VStack(spacing: 2) {
                        Text(String(format: "%.0f", speed))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(unit)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(width: 50, height: 50)
                    .background(
                        .ultraThinMaterial
                    )
                    .clipShape(.circle)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let stemWidth = w * 0.05
        let headHeight = h * 0.1

        path.move(to: CGPoint(x: w / 2 - stemWidth / 2, y: h / 2))
        path.addLine(to: CGPoint(x: w / 2 - stemWidth / 2, y: headHeight + stemWidth))
        path.addLine(to: CGPoint(x: w / 2 - stemWidth, y: headHeight + stemWidth))
        path.addLine(to: CGPoint(x: w / 2, y: 0))
        path.addLine(to: CGPoint(x: w / 2 + stemWidth, y: headHeight + stemWidth))
        path.addLine(to: CGPoint(x: w / 2 + stemWidth / 2, y: headHeight + stemWidth))
        path.addLine(to: CGPoint(x: w / 2 + stemWidth / 2, y: h / 2))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CompassWindView(direction: 90, speed: 36)
        .frame(width: 150, height: 150)
        .padding()
}

