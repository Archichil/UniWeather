//
//  ForecastPlayerView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import SwiftUI

struct ForecastPlayerView: View {
    private let impactGenerator = UIImpactFeedbackGenerator(style: .soft)
    @ObservedObject var viewModel: MapViewModel

    // TODO: Add localization
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(languageCode: .russian)
        return formatter
    }()

    private enum Constants {
        enum Time {
            static let timeStep: TimeInterval = 3 * 3600
            static let maxForwardTime: TimeInterval = 24 * 3600
        }

        enum Text {
            static let frameTitle: String = String(localized: "forecastPlayerView.frameTitle")
            static let timeIncrement: String = String(localized: "forecastPlayerView.timeIncrement")
            static let timeDecrement: String = String(localized: "forecastPlayerView.timeDecrement")
        }

        enum Icons {
            static let backward: String = "backward.fill"
            static let forward: String = "forward.fill"
        }

        enum Layout {
            static let vStackSpacing: CGFloat = 8
            static let padding: CGFloat = 8
            static let cornerRadius: CGFloat = 16
            static let arrowsFrameWidth: CGFloat = 200
        }
    }

    var body: some View {
        VStack(spacing: Constants.Layout.vStackSpacing) {
            Text(Constants.Text.frameTitle)
                .font(.headline)
            Text(ForecastPlayerView.dateFormatter.string(from: viewModel.date))
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Button(action: {
                    impactGenerator.impactOccurred()
                    viewModel.stepBackward()
                }) {
                    Text(Constants.Text.timeDecrement)
                        .foregroundStyle(.secondary)
                    Image(systemName: Constants.Icons.backward)
                }
                .disabled(viewModel.isBackwardDisabled)
                .foregroundColor(viewModel.isBackwardDisabled ? .gray : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: {
                    impactGenerator.impactOccurred()
                    viewModel.stepForward()
                }) {
                    Image(systemName: Constants.Icons.forward)
                    Text(Constants.Text.timeIncrement)
                        .foregroundStyle(.secondary)
                }
                .disabled(viewModel.isForwardDisabled)
                .foregroundColor(viewModel.isForwardDisabled ? .gray : .primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(width: Constants.Layout.arrowsFrameWidth)
            .buttonStyle(.plain)
            .padding(Constants.Layout.padding)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(Constants.Layout.cornerRadius)
    }
}

#Preview {
    ForecastPlayerView(viewModel: MapViewModel())
}
