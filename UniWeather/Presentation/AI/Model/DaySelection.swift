//
//  DaySelection.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

enum DaySelection: String, CaseIterable, Identifiable {
    case Today
    case Tomorrow
//    case AfterTomorrow

    var id: String { self.rawValue }
}
