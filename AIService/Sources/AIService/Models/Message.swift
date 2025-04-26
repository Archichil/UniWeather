//
//  Message.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

import APIClient

public struct Message: DecodableType {
    public let content: String
    public let refusal: String?
}
