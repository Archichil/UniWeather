//
//  DropUpMenu.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct DropUpMenu: View {
    @ObservedObject var viewModel: AIViewModel
    
    @Binding var showDropdown: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if showDropdown {
                ScrollView {
                    ForEach(AvailablePrompts.allCases, id: \.self) { prompt in
                        Button(action: {
                            withAnimation {
                                viewModel.handleItemClick(prompt)
                                showDropdown.toggle()
                            }
                        }, label: {
                            HStack(spacing: 15) {
                                Image(systemName: prompt.iconName)
                                    .frame(maxWidth: 20)
                                Text(prompt.rawValue)
                                    .lineLimit(1)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                        })
                    }
                }
                .highPriorityGesture(DragGesture())
                .padding(.top, 10)
                .frame(maxWidth: .infinity, maxHeight: 150)
                .background(Color(red: 23 / 255, green: 27 / 255, blue: 30 / 255))
                .zIndex(1)
            }
            
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }, label: {
                HStack {
                    Image(systemName: "line.3.horizontal")
                    Text("Check other prompts")
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white)
            })
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            .background(Color(red: 20 / 255, green: 24 / 255, blue: 27 / 255))

        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

#Preview {
    PromptDetailView(viewModel: AIViewModel())
}
