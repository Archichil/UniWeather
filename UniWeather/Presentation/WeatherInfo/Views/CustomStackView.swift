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
    
    // MARK: - Constants
    let sectionTopSafeArea: CGFloat = 145
    let titleHeight: CGFloat = 38
    let cornerRadius: CGFloat = 12
    
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
                .frame(height: titleHeight)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial, in: CustomCorner(corners: bottomOffset < titleHeight ? .allCorners : [.topLeft, .topRight], radius: cornerRadius))
                .zIndex(1)
            
            VStack(spacing: 0) {
                Divider()
                
                contentView
                    .padding(.bottom)
                    .padding(.top, 12)
            }
            .background(.ultraThinMaterial, in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: cornerRadius))
            .offset(y: topOffset >= sectionTopSafeArea ? 0 : -(-topOffset + sectionTopSafeArea))
            .zIndex(0)
            .clipped()
            .opacity(getOpacity())
        }
        .clipShape(.rect(cornerRadius: cornerRadius))
        .opacity(getOpacity())
        .offset(y: topOffset >= sectionTopSafeArea ? 0 : -topOffset + sectionTopSafeArea)
        .background {
            GeometryReader { proxy -> Color in
                let minY = proxy.frame(in: .global).minY
                let maxY = proxy.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                    self.bottomOffset = maxY - sectionTopSafeArea
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
    let titleHeight: CGFloat = 38
    let cornerRadius: CGFloat = 12
    
    func body(content: Content) -> some View {
        if bottomOffset < titleHeight {
            content
        } else {
            content
                .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
}
