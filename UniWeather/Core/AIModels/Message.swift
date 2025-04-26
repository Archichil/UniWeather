//
//  Message.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

import APIClient

struct Message: DecodableType {
    let content: String
    let refusal: String?
}
