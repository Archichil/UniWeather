//
//  LocationTitle.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI

struct LocationTitle: View {
    let location: String
    
    var body: some View {
        HStack(spacing: 0) {
            Text(location)
                .lineLimit(1)
                .bold()
                .font(.system(size: 15))
            
            Image(systemName: "location.fill")
                .font(.system(size: 10))
                .padding(.horizontal, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.white)
    }
}
