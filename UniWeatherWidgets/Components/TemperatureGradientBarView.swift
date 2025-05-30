//
//  TemperatureGradientBarView.swift
//  UniWeather
//
//  Created by Daniil on 4.05.25.
//

import SwiftUI

private let allStops: [(value: Double, color: Color)] = [
    (-55, Color(hex: "821692")),
    (-40, Color(hex: "821692")),
    (-30, Color(hex: "8257DB")),
    (-10, Color(hex: "20C4E8")),
    (0, Color(hex: "23DDDD")),
    (20, Color(hex: "FFF028")),
    (25, Color(hex: "FFC228")),
    (30, Color(hex: "FC8014")),
    (40, Color(hex: "9C2B1E")),
    (50, Color(hex: "9C2B1E")),
]

struct TemperatureGradientBarView: View {
    let overallMin: Double
    let overallMax: Double

    let dayMin: Double
    let dayMax: Double

    private let barHeight: CGFloat = 4

    // MARK: — Fractions for this low/high segment

    private var startFraction: CGFloat {
        CGFloat((dayMin - overallMin) / (overallMax - overallMin))
    }

    private var endFraction: CGFloat {
        CGFloat((dayMax - overallMin) / (overallMax - overallMin))
    }

    private var widthFraction: CGFloat {
        max(0, endFraction - startFraction)
    }

    var body: some View {
        HStack(spacing: 8) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: barHeight)

                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(stops: gradientStops(in: geo.size.width)),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(
                            width: geo.size.width * widthFraction,
                            height: barHeight
                        )
                        .offset(x: geo.size.width * startFraction)
                }
                .frame(height: barHeight)
            }
        }
    }

    private func gradientStops(in _: CGFloat) -> [Gradient.Stop] {
        let fullStops = allStops
            .sorted { $0.value < $1.value }
        var result: [Gradient.Stop] = []

        for (value, color) in fullStops {
            let loc: CGFloat = if dayMax == dayMin {
                0.5 // Default to midpoint if dayMax equals dayMin
            } else {
                CGFloat((value - dayMin) / (dayMax - dayMin))
            }
            let clamped = min(max(loc, 0), 1)
            result.append(.init(color: color, location: clamped))
        }
        // Guarantee endpoints at 0 and 1
        if let first = result.first, first.location > 0 {
            result.insert(.init(color: first.color, location: 0), at: 0)
        }
        if let last = result.last, last.location < 1 {
            result.append(.init(color: last.color, location: 1))
        }
        return result
    }
}
