//
//  SavedLocationItem.swift
//  UniWeather
//
//  Created by Daniil on 11.04.25.
//

import SwiftUI

struct SavedLocationItem: View {
    var current: Date
    var sunrise: Date
    var sunset: Date
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: current)
    }
    
    var gradient: Gradient {
        let calendar = Calendar.current
        
        // Рассветные интервалы
        let sunriseMinus1H = calendar.date(byAdding: .hour, value: -1, to: sunrise)!
        let sunriseMinus30M = calendar.date(byAdding: .minute, value: -30, to: sunrise)!
        let sunrisePlus30M = calendar.date(byAdding: .minute, value: 30, to: sunrise)!
        let sunrisePlus1H = calendar.date(byAdding: .hour, value: 1, to: sunrise)!
        let sunrisePlus2H = calendar.date(byAdding: .hour, value: 2, to: sunrise)!
        let sunrisePlus3H = calendar.date(byAdding: .hour, value: 3, to: sunrise)!
        let sunrisePlus4H = calendar.date(byAdding: .hour, value: 4, to: sunrise)!
        let sunrisePlus5H = calendar.date(byAdding: .hour, value: 5, to: sunrise)!
        
        // Закатные интервалы
        let sunsetMinus3H = calendar.date(byAdding: .hour, value: -3, to: sunset)!
        let sunsetMinus2H = calendar.date(byAdding: .hour, value: -2, to: sunset)!
        let sunsetMinus1H = calendar.date(byAdding: .hour, value: -1, to: sunset)!
        let sunsetMinus30M = calendar.date(byAdding: .minute, value: -30, to: sunset)!
        let sunsetPlus30M = calendar.date(byAdding: .minute, value: 30, to: sunset)!
        let sunsetPlus1H = calendar.date(byAdding: .hour, value: 1, to: sunset)!
        
        switch current {
        case ..<sunriseMinus1H:
            return Gradient(colors: [Color(hex: "#0A1F3A"), Color(hex: "#3A2D6D")])
        case sunriseMinus1H..<sunriseMinus30M:
            return Gradient(colors: [Color(hex: "#3A2D6D"), Color(hex: "#5E4B8B")])
        case sunriseMinus30M..<sunrise:
            return Gradient(colors: [Color(hex: "#5E4B8B"), Color(hex: "#FF9A8B")])
            
      
        case sunrise..<sunrisePlus30M:
            return Gradient(colors: [
                Color(hex: "#344579"),
                Color(hex: "#b58875"),
            ])

        case sunrisePlus30M..<sunrisePlus1H:
            return Gradient(colors: [
                Color(hex: "#344579"),
                Color(hex: "#b7b6c9"),
            ])

        case sunrisePlus1H..<sunrisePlus2H:

            return Gradient(colors: [
                Color(hex: "#344579"),
                Color(hex: "#b7b6c9"),
            ])
            
        case sunrisePlus2H..<sunrisePlus3H:
            return Gradient(colors: [Color(hex: "#6DC8F3"), Color(hex: "#4AB8D6")])
        case sunrisePlus3H..<sunrisePlus4H:
            return Gradient(colors: [Color(hex: "#4AB8D6"), Color(hex: "#47ABE8")])
        case sunrisePlus4H..<sunrisePlus5H:
            return Gradient(colors: [Color(hex: "#47ABE8"), Color(hex: "#3A97D9")])
        case sunrisePlus5H..<sunsetMinus3H:
            return Gradient(colors: [Color(hex: "#3A97D9"), Color(hex: "#8ACBFF")])
        case sunsetMinus3H..<sunsetMinus2H:
            return Gradient(colors: [Color(hex: "#8ACBFF"), Color(hex: "#7AB8EB")])
        case sunsetMinus2H..<sunsetMinus1H:
            return Gradient(colors: [Color(hex: "#7AB8EB"), Color(hex: "#FF9A8B")])
        case sunsetMinus1H..<sunsetMinus30M:
            return Gradient(colors: [Color(hex: "#FF9A8B"), Color(hex: "#FF7E5F")])
        case sunsetMinus30M..<sunset:
            return Gradient(colors: [Color(hex: "#FF7E5F"), Color(hex: "#FEB47B")])
        case sunset..<sunsetPlus30M:
            return Gradient(colors: [Color(hex: "#FEB47B"), Color(hex: "#A569BD")])
        case sunsetPlus30M..<sunsetPlus1H:
            return Gradient(colors: [Color(hex: "#A569BD"), Color(hex: "#3A2D6D")])
        default:
            return Gradient(colors: [Color(hex: "#3A2D6D"), Color(hex: "#0A1F3A")])
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Минск")
                        .font(.title2)
                    
                    Text(timeString)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                
                Text("4º")
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("Облачно")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Макс.:4º, мин.:-3º")
                    .font(.callout)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 16)
        .padding(.horizontal)
        .foregroundStyle(.white)
        .background(LinearGradient(
            gradient: gradient,
            startPoint: .top,
            endPoint: .bottom
        ))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(16)
    }
}

#Preview {
    let calendar = Calendar.current
    let now = Date()
    let sunrise = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: now)!
    let sunset = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now)!
    
    // Ключевые точки времени для проверки интервалов
    let testTimes: [(time: Date, description: String)] = [
        (calendar.date(bySettingHour: 5, minute: 0, second: 0, of: now)!, "Глубокая ночь (5:00)"),
        (calendar.date(bySettingHour: 6, minute: 0, second: 0, of: now)!, "Предрассвет (-1ч)"),
        (calendar.date(bySettingHour: 6, minute: 30, second: 0, of: now)!, "Начало рассвета (-30м)"),
        (calendar.date(bySettingHour: 7, minute: 0, second: 0, of: now)!, "Рассвет (7:00)"),
        (calendar.date(bySettingHour: 7, minute: 30, second: 0, of: now)!, "Яркий рассвет (+30м)"),
        (calendar.date(bySettingHour: 8, minute: 0, second: 0, of: now)!, "Утро (+1ч)"),
        (calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)!, "Утро (+2ч)"),
        (calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!, "День (+3ч)"),
        (calendar.date(bySettingHour: 11, minute: 0, second: 0, of: now)!, "Яркий день (+4ч)"),
        (calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!, "Полдень (+5ч)"),
        (calendar.date(bySettingHour: 16, minute: 0, second: 0, of: now)!, "Начало вечера (-3ч)"),
        (calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now)!, "Вечер (-2ч)"),
        (calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!, "Золотой час (-1ч)"),
        (calendar.date(bySettingHour: 18, minute: 30, second: 0, of: now)!, "Яркий закат (-30м)"),
        (calendar.date(bySettingHour: 19, minute: 0, second: 0, of: now)!, "Закат (19:00)"),
        (calendar.date(bySettingHour: 19, minute: 30, second: 0, of: now)!, "Сумерки (+30м)"),
        (calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!, "Поздние сумерки (+1ч)"),
        (calendar.date(bySettingHour: 22, minute: 0, second: 0, of: now)!, "Ночь")
    ]
    
    return ScrollView {
        VStack(spacing: 10) {
            ForEach(testTimes, id: \.description) { time in
                SavedLocationItem(
                    current: time.time,
                    sunrise: sunrise,
                    sunset: sunset
                )
                .overlay(
                    Text(time.description)
                        .font(.caption)
                        .padding(4)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(4)
                        .padding(4),
                    alignment: .topLeading
                )
            }
        }
    }
    .preferredColorScheme(.dark)
}
