//
//  CompassWindView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 4.05.25.
//

import SwiftUI

struct CompassWindView: View {
    var direction: Double
    var speed: Double?
    var unit: String = "км/ч"
    
    private let cardinalLabels = ["C": 0.0, "В": 90.0, "Ю": 180.0, "З": 270.0]
    private let majorTickCount = 60

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                Canvas { context, _ in
                    let center = CGPoint(x: size/2, y: size/2)
                    let circle = Path(ellipseIn: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
                    context.stroke(circle, with: .color(.secondary), lineWidth: 1)

                    for tick in 0..<majorTickCount {
                        let angle = Angle(degrees: Double(tick) * 360.0 / Double(majorTickCount))
                        let lineLength: CGFloat = (tick % 5 == 0 ? 12 : 6)
                        let strokeWidth: CGFloat = (tick % 5 == 0 ? 2 : 1)
                        let start = CGPoint(
                            x: center.x + cos(CGFloat(angle.radians)) * (size/2 - lineLength),
                            y: center.y + sin(CGFloat(angle.radians)) * (size/2 - lineLength)
                        )
                        let end = CGPoint(
                            x: center.x + cos(CGFloat(angle.radians)) * (size/2),
                            y: center.y + sin(CGFloat(angle.radians)) * (size/2)
                        )
                        var tickPath = Path()
                        tickPath.move(to: start)
                        tickPath.addLine(to: end)
                        context.stroke(tickPath, with: .color(.primary.opacity(0.3)), lineWidth: strokeWidth)
                    }

                    var arrowPath = Path { path in
                        let w = size * 0.05
                        let h = size * 0.7
                        let stem = w * 0.05
                        let headH = h * 0.1
                        let origin = CGPoint(x: center.x - w/2, y: center.y + h/2)
                        path.move(to: CGPoint(x: origin.x + w/2, y: origin.y))
                        path.addLine(to: CGPoint(x: origin.x + w/2, y: origin.y - (h - headH)))
                        path.addLine(to: CGPoint(x: origin.x, y: origin.y - (h - headH) + stem))
                        path.addLine(to: CGPoint(x: origin.x + w/2, y: origin.y - h))
                        path.addLine(to: CGPoint(x: origin.x + w, y: origin.y - (h - headH) + stem))
                        path.addLine(to: CGPoint(x: origin.x + w/2, y: origin.y - (h - headH)))
                    }
                    arrowPath = arrowPath
                        .applying(CGAffineTransform(translationX: -size/2, y: -size/2))
                        .applying(CGAffineTransform(rotationAngle: CGFloat((direction) * .pi/180)))
                        .applying(CGAffineTransform(translationX: size/2, y: size/2))
                    context.stroke(arrowPath, with: .color(.white), lineWidth: 2)
                }
                .frame(width: size, height: size)
                .drawingGroup()

                ForEach(cardinalLabels.sorted(by: { $0.value < $1.value }), id: \.key) { label, rawAngle in
                    let adjusted = CGFloat((rawAngle - 90) * .pi / 180)
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .position(
                            x: size/2 + cos(adjusted) * (size/2 - 16),
                            y: size/2 + sin(adjusted) * (size/2 - 16)
                        )
                }

                if let speed = speed {
                    VStack(spacing: 1) {
                        Text(String(format: "%.0f", speed))
                            .font(.headline)
                            .bold()
                        Text(unit)
                            .font(.caption2)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                }
            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    CompassWindView(direction: 270, speed: 36)
        .frame(width: 150, height: 150)
        .padding()
}
