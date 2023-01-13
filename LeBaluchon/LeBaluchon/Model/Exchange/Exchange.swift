//
//  Exchange.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 10/01/2023.
//

import Foundation

class Exchange {
    // Save the current rate
    static var rate: Double?
    
    enum CurrencyError: Error {
        case unknownRate
        
        var localizedDescription: String {
            switch self {
            case .unknownRate:
                return "Unknown exchange rate, please refresh it."
            }
        }
    }
    
    static func convertCurrency(amount: Double) throws -> String {
        guard let rate = rate else {
            throw CurrencyError.unknownRate
        }
        
        // I prefer to use a String method, because with Doubles,
        // it seems to be unstable
        return String(format: "%.2f", (rate * amount))
    }
}
