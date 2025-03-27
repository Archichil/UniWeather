//
//  DaySelectionView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct DaySelectionView: View {
    @Binding var showDaySheet: Bool
    @Binding var showAnswerSheet: Bool
    @ObservedObject var viewModel: AIViewModel
    
    var body: some View {
        VStack {
            Text("Choose the day:")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Picker("Choose the day", selection: $viewModel.selectedDay) {
                ForEach(DaySelection.allCases) { day in
                    Text(day.rawValue).tag(day)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Button(action: {
                showDaySheet = false
                showAnswerSheet = true
            }) {
                Text("Continue")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    AIView()
}
