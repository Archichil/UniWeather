//
//  Snow.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

import APIClient

struct Snow: DecodableType {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
