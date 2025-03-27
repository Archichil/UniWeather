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
    
    private var dates: [Date] {
        let calendar = Calendar.current
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: Date())! }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Choose the date")
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.medium)
                .padding()
            
            Picker("Выберите дату", selection: $viewModel.selectedDayIndex) {
                ForEach(0..<dates.count, id: \.self) { index in
                    Text(formattedDate(for: index))
                        .tag(index)
                        .foregroundStyle(.white)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity, maxHeight: 130)
            .clipped()
            
            Button(action: {
                showDaySheet = false
                showAnswerSheet = true
            }) {
                Text("Continue")
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.8))
                    .cornerRadius(50)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .cornerRadius(12)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func formattedDate(for index: Int) -> String {
        if index == 0 {
            return "Today"
        } else if index == 1 {
            return "Tomorrow"
        } else {
            return dateFormatter.string(from: dates[index])
        }
    }
}

#Preview {
    AIView()
}
