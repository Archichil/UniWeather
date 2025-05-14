//
//  MainView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI

let secondaryColor: Color = .white.opacity(0.5)

private struct InfoCircleView: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: icon)
            Text(text)
                .padding(.leading, 2)
        }
        .font(.system(size: 11))
        .background(
            Circle().fill(.ultraThinMaterial)
                .frame(width: 35, height: 35)
        )
        .frame(width: 35, height: 35)
    }
}

struct MainView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Минск")
                    .font(.title3)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("1")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                
                
                Text("Временами облачно")
                    .font(.caption2)
                    .foregroundStyle(secondaryColor)
                    .fontWeight(.medium)
                
                HStack(spacing: 6) {
                    HStack(spacing: 1) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 11))
                            .fontWeight(.bold)
                        Text("14º")
                    }
                    
                    HStack(spacing: 1) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 11))
                            .fontWeight(.bold)
                        Text("7º")
                    }
                }
                .font(.system(size: 13))
                .fontWeight(.semibold)
                .padding(.top, 3)
            }.frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                InfoCircleView(icon: "thermometer.variable", text: "37º")
                Spacer()
                InfoCircleView(icon: "umbrella.fill", text: "40%")
                Spacer()
                InfoCircleView(icon: "drop.fill", text: "80%")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainView()
}
