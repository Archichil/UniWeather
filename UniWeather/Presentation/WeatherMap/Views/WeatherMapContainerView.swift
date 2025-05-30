//
//  WeatherMapContainerView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 27.03.25.
//

import SwiftUI
import WeatherMapService

struct WeatherMapContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MapViewModel()

    private enum Constants {
        enum Layout {
            static let cornerRadius: CGFloat = 8
            static let horizontalPadding: CGFloat = 8
            static let padding: CGFloat = 8
            static let readyButtonPadding: CGFloat = 10
        }

        enum Icons {
            static let layers = "square.3.layers.3d"
        }

        enum Texts {
            static let ready = String(localized: "weatherMapContainerView.ready")
        }
    }

    var body: some View {
        ZStack {
            WeatherMapRenderer(viewModel: viewModel)
                .ignoresSafeArea(edges: .all)
                .onTapGesture {
                    viewModel.userDidInteract()
                }
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: {
                            dismiss.callAsFunction()
                        }) {
                            Text(Constants.Texts.ready)
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(Constants.Layout.readyButtonPadding)
                                .foregroundStyle(.background)
                                .colorInvert()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
                        }

                        GradientLegendView(propertyName: viewModel.selectedLayer.measurementValue, colorLevels: viewModel.selectedLayer.colorLevels)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(viewModel.isUIVisible ? 1 : 0)
                            .animation(.easeInOut, value: viewModel.isUIVisible)
                    }
                    Menu {
                        ForEach(WeatherMapConfiguration.MapLayer.allCases) { layer in
                            Button(action: {
                                viewModel.selectedLayer = layer
                            }) {
                                Text(viewModel.selectedLayer.displayName == layer.displayName ? "⎷ \(layer.displayName)" : layer.displayName)
                                    .padding(Constants.Layout.padding)
                                    .foregroundColor(.white)
                                    .cornerRadius(Constants.Layout.cornerRadius)
                                Image(systemName: layer.displayIcon)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    } label: {
                        Image(systemName: Constants.Icons.layers)
                            .font(.title2)
                            .padding(Constants.Layout.padding)
                            .foregroundStyle(.background)
                            .colorInvert()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, Constants.Layout.horizontalPadding)
                .frame(maxHeight: .infinity, alignment: .top)

                ForecastPlayerView(viewModel: viewModel)
                    .opacity(viewModel.isUIVisible ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.isUIVisible)
                    .onTapGesture {
                        viewModel.userDidInteract()
                    }
            }
        }
        .toolbar(.hidden)
        .onAppear {
            viewModel.userDidInteract()
        }
    }
}

#Preview {
    WeatherMapContainerView()
}
