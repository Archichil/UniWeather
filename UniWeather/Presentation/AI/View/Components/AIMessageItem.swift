//
//  AIMessageItem.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct AIMessageItem: View {
    var text: String
    var time: String
    var messageId: UUID
    var isAnswer: Bool
    let cornerRadiusPrimary = 15.0
    let cornerRadiusSecondary = 5.0
    @State private var offset: CGFloat = 0
    @Binding var animationStarted: Bool
    
    var body: some View {
        VStack(alignment: isAnswer ? .leading : .trailing) {
            Text(.init(text))
                .padding(16)
                .foregroundStyle(.white)
                .frame(minWidth: 100, alignment: isAnswer ? .leading : .trailing)
                .background(
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: cornerRadiusPrimary,
                        bottomLeading: isAnswer ? cornerRadiusSecondary : cornerRadiusPrimary,
                        bottomTrailing: isAnswer ? cornerRadiusPrimary : cornerRadiusSecondary,
                        topTrailing: cornerRadiusPrimary),
                                           style: .continuous
                    )
                    .foregroundStyle(
                        isAnswer ? Color(red: 36 / 255, green: 36 / 255, blue: 38 / 255)
                        : Color(red: 52 / 255, green: 54 / 255, blue: 58 / 255))
                )
                .offset(x: offset)
                .onAppear {
                    if !animationStarted {
                        animationStarted = true
                        offset = isAnswer ? -300 : 300
                        withAnimation(.easeOut(duration: 0.5)) {
                            offset = 0
                        }
                    }
                }
            
            HStack(spacing: 0) {
                if (isAnswer) {
                    Text("DeepSeek AI")
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Image(systemName: "sparkles")
                        .foregroundStyle(.white.opacity(0.8))
                }
                Text(" \(time)")
                    .foregroundStyle(.gray)
            }
            .font(.caption)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity, alignment: isAnswer ? .leading : .trailing)
        }
        .frame(maxWidth: 320)
    }
}

#Preview {
    AIChatView(viewModel: AIViewModel())
}
