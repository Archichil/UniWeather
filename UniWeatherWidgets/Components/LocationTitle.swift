//
//  LocationTitle.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI

struct LocationTitle: View {
    let location: String
    let textSize: CGFloat
    var isCurrentLocation: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            Text(location)
                .lineLimit(1)
                .fontWeight(.semibold)
                .font(.system(size: textSize))

            if isCurrentLocation {
                Image(systemName: "location.fill")
                    .font(.system(size: textSize * 2 / 3))
                    .padding(.horizontal, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.white)
    }
}
