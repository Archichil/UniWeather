//
//  ChatCompletionResponse.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

import APIClient

public struct ChatCompletionResponse: DecodableType {
    public let id: String
    public let created: Int
    public let choices: [Choice]
}
