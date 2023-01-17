//
//  Weather.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 16/01/2023.
//

import Foundation

struct WeatherSupport {
    // MARK: - Functions
    func roundedTemperature(temperature: Double) -> String {
        // Rounding at the nearest Integer
        return String(format: "%.0f", temperature)
    }
    
    func removeLineBreak(from: String?) -> String? {
        // We can have multiples weather description
        // So when the last comes, we remove the line break
        // at the end because we don't need it
        guard let from = from, from.hasSuffix("\n") else {
            return nil
        }
                
        // Removing the "\n"
        return String(from.dropLast(1))
    }
}
