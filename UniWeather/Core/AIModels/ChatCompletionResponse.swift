//
//  ChatCompletionResponse.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

struct ChatCompletionResponse: DecodableType {
    let id: String
    let created: Int
    let choices: [Choice]
}
