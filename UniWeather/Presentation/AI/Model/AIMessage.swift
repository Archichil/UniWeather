//
//  AIMessage.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct AIMessage: Identifiable {
    var id: UUID = UUID()
    let text: String
    let time: String
    let isAnswer: Bool
}
