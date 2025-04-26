//
//  Date+TimeFloor.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 28.03.25.
//

import Foundation

public extension Date {
    func roundedToNearestHour() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        return calendar.date(from: components) ?? self
    }
}
