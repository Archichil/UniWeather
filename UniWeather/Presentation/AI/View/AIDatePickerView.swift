//
//  AIDatePickerView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIDatePickerView: View {
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let text = Color.white
            static let buttonText = Color.black
            static let buttonBackground = Color.white.opacity(0.8)
        }
        
        enum Layout {
            static let verticalSpacing: CGFloat = 0
            static let horizontalSpacing: CGFloat = 0
            static let topPadding: CGFloat = 8
            static let cornerRadius: CGFloat = 50
            static let pickerHeight: CGFloat = 190
            static let titleFont: Font = .title
            static let buttonFontWeight: Font.Weight = .medium
            static let buttonPadding: CGFloat = 12
        }
        
        enum Text {
            static let title = "Choose the date"
            static let continueButton = "Continue"
        }
        
        enum DateFormat {
            static let format = "dd MMMM"
            static let today = "Today"
            static let tomorrow = "Tomorrow"
            static let daysCount = 7
            static let todayIndex = 0
            static let tomorrowIndex = 1
        }
    }
    
    // MARK: - Properties
    @Binding var showDaySheet: Bool
    @Binding var showAnswerSheet: Bool
    @ObservedObject var viewModel: AIViewModel
    @Environment(\.dismiss) var dismiss
    
    private var dates: [Date] {
        let calendar = Calendar.current
        return (0..<Constants.DateFormat.daysCount).map {
            calendar.date(byAdding: .day, value: $0, to: Date())!
        }
    }
    
    // MARK: - Views
    var body: some View {
        VStack(spacing: Constants.Layout.verticalSpacing) {
            HStack(spacing: Constants.Layout.horizontalSpacing) {
                titleView
                    .frame(maxWidth: .infinity, alignment: .leading)
                DismissButton(action: dismiss.callAsFunction)
            }
            .padding(.top, Constants.Layout.topPadding)
            .padding()
            pickerView
            continueButton
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .cornerRadius(Constants.Layout.cornerRadius)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var titleView: some View {
        Text(Constants.Text.title)
            .font(Constants.Layout.titleFont)
            .foregroundStyle(Constants.Colors.text)
            .fontWeight(Constants.Layout.buttonFontWeight)
    }
    
    private var pickerView: some View {
        Picker(Constants.Text.title, selection: $viewModel.selectedDayIndex) {
            ForEach(0..<dates.count, id: \.self) { index in
                Text(formattedDate(for: index))
                    .tag(index)
                    .foregroundStyle(Constants.Colors.text)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(maxWidth: .infinity, maxHeight: Constants.Layout.pickerHeight)
        .clipped()
    }
    
    private var continueButton: some View {
        Button(action: handleContinue) {
            Text(Constants.Text.continueButton)
                .foregroundColor(Constants.Colors.buttonText)
                .fontWeight(Constants.Layout.buttonFontWeight)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Constants.Colors.buttonBackground)
                .cornerRadius(Constants.Layout.cornerRadius)
        }
        .padding(Constants.Layout.buttonPadding)
    }
    
    // MARK: - Helper Methods
    private func formattedDate(for index: Int) -> String {
        switch index {
        case Constants.DateFormat.todayIndex:
            return Constants.DateFormat.today
        case Constants.DateFormat.tomorrowIndex:
            return Constants.DateFormat.tomorrow
        default:
            return dateFormatter.string(from: dates[index])
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.format
        return formatter
    }
    
    private func handleContinue() {
        guard let prompt = viewModel.selectedPrompt else { return }
        showDaySheet = false
        showAnswerSheet = true
        viewModel.handleItemClick(prompt)
    }
}
