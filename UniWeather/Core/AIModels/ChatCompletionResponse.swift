//
//  ChatCompletionResponse.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

import APIClient

struct ChatCompletionResponse: DecodableType {
    let id: String
    let created: Int
    let choices: [Choice]
}
