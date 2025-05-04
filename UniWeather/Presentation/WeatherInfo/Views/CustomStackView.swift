//
//  WeatherStackView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 2.05.25.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View >: View {
    var titleView: Title
    var contentView: Content
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    
    init(@ViewBuilder titleView: @escaping () -> Title, @ViewBuilder contentView: @escaping () -> Content) {
        self.titleView = titleView()
        self.contentView = contentView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .padding(.horizontal)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: CustomCorner(corners: bottomOffset < 38 ? .allCorners : [.topLeft, .topRight], radius: 12))
                .zIndex(1)
            
            VStack(spacing: 0) {
                Divider()
                
                contentView
                    .padding(.bottom)
                    .padding(.top, 12)
            }
            .background(.ultraThinMaterial, in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: 12))
            .offset(y: topOffset >= 145 ? 0 : -(-topOffset + 145))
            .zIndex(0)
            .clipped()
            .opacity(getOpacity())
        }
        .clipShape(.rect(cornerRadius: 12))
        .opacity(getOpacity())
        .offset(y: topOffset >= 145 ? 0 : -topOffset + 145)
        .background {
            GeometryReader { proxy -> Color in
                let minY = proxy.frame(in: .global).minY
                let maxY = proxy.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                    self.bottomOffset = maxY - 145
                }
                return Color.clear
            }
        }
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
    }
    
    func getOpacity() -> CGFloat {
        if bottomOffset < 28 {
            let progress = bottomOffset / 28
            
            return progress
        }
        return 1
    }
}

struct CornerModifier: ViewModifier {
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        if bottomOffset < 38 {
            content
        } else {
            content
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}
