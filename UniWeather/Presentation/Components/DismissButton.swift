//
//  DismissButton.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 30.03.25.
//

import SwiftUI

struct DismissButton: View {
    let action: () -> Void

    private enum Constants {
        enum Layout {
            static let circleWidth: CGFloat = 30
            static let circleHeight: CGFloat = 30
        }

        enum Icons {
            static let closeIcon: String = "xmark"
        }

        enum Colors {
            static let circleColor: Color = .gray.opacity(0.2)
            static let iconColor: Color = .gray
        }

        enum Fonts {
            static let imageSize: CGFloat = 15
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Constants.Colors.circleColor)
                    .frame(width: Constants.Layout.circleWidth, height: Constants.Layout.circleHeight)
                Image(systemName: Constants.Icons.closeIcon)
                    .foregroundColor(Constants.Colors.iconColor)
                    .font(.system(size: Constants.Fonts.imageSize, weight: .heavy))
            }
        }
    }
}

#Preview {
    DismissButton(action: {})
}
