//
//  GradientLegendView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 26.03.25.
//

import SwiftUI

struct GradientLegendView: View {
    let propertyName: String
    let colorLevels: [(key: String, value: Color)]

    private enum Constants {
        enum Gradient {
            static let height: CGFloat = 150
            static let width: CGFloat = 10
            static let cornerRadius: CGFloat = 10
        }

        enum Text {
            static let horizontalPadding: CGFloat = 16
            static let verticalPadding: CGFloat = 8
        }

        enum Spacing {
            static let betweenElements: CGFloat = 8
            static let zero: CGFloat = 0
        }
    }

    var body: some View {
        VStack(spacing: Constants.Spacing.zero) {
            Text(propertyName)
                .padding(.horizontal, Constants.Text.horizontalPadding)
                .padding(.vertical, Constants.Text.verticalPadding)
                .font(.caption2)
                .bold()
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .center)

            Divider()
                .frame(maxWidth: .infinity)

            HStack(alignment: .center, spacing: Constants.Spacing.betweenElements) {
                LinearGradient(
                    gradient: Gradient(colors: colorLevels.map(\.value)),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: Constants.Gradient.width, height: Constants.Gradient.height)
                .cornerRadius(Constants.Gradient.cornerRadius)

                VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
                    ForEach(Array(colorLevels.enumerated()), id: \.element.key) { _, level in
                        Text(level.key)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(height: Constants.Gradient.height / CGFloat(colorLevels.count))
                    }
                }
                .frame(height: Constants.Gradient.height)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Constants.Text.verticalPadding)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Gradient.cornerRadius))
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    GradientLegendView(propertyName: "Температура", colorLevels: [
        ("1", Color(hex: "ACAAF7")),
        ("10", Color(hex: "8D8AF3")),
        ("20", Color(hex: "706EC2")),
        ("40", Color(hex: "5658FF")),
        ("100", Color(hex: "5B5DB1")),
        ("200", Color(hex: "3E3F85")),
        ("400", Color(hex: "3E3F85")),
        ("600", Color(hex: "3E3F85")),
        ("1000", Color(hex: "3E3F85")),
    ])
}
