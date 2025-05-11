//
//  Array+Chunked.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 2.04.25.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
