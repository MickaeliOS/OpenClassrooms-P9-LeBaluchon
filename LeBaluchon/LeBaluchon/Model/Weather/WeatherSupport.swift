//
//  Weather.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 16/01/2023.
//

import Foundation

struct WeatherSupport {
    func roundedTemperature(temperature: Double) -> String {
        // Rounding at the nearest Integer
        return String(format: "%.0f", temperature)
    }
    
    func removeComma(from: String?) -> String? {
        // Since there are multiples descriptions
        // we remove the last comma which separates the descriptions
        guard let from = from else {
            return nil
        }
        
        return String(from.dropLast(2))
    }
}
