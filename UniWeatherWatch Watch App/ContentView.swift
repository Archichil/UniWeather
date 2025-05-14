//
//  ContentView.swift
//  UniWeatherWatch Watch App
//
//  Created by Daniil on 13.05.25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TabView {
                MainView()
                MainView()
                MainView()
            }
            .tabViewStyle(.carousel)
            
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20))
                .padding(8)
                .background(
                    Circle()
                        .fill(.thinMaterial)
                )
                .padding(.top, 12)
                .padding(.leading, 12)
        }
        .background(.gray)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
