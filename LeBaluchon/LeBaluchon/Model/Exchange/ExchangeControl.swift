//
//  Exchange.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 10/01/2023.
//

import Foundation

class ExchangeControl {
    // MARK: - Variables
    static var rate: Double?
    
    // MARK: - Enums
    enum CurrencyError: Error {
        case unknownRate
        
        var localizedDescription: String {
            switch self {
            case .unknownRate:
                return "Unknown exchange rate, please refresh it."
            }
        }
    }
    
    enum AmountError: Error {
        case emptyAmount
        case incorrectAmount
        
        var localizedDescription: String {
            switch self {
            case .emptyAmount:
                return "Please fill a currency you want to convert."
            case .incorrectAmount:
                return "Please provide correct amount."
            }
        }
    }
    
    // MARK: - Functions
    func convertCurrency(amount: Double) throws -> String {
        guard let rate = ExchangeControl.rate else {
            throw CurrencyError.unknownRate
        }
        
        // To round, I prefer to use a String method, because with Doubles,
        // it seems to be unstable
        return String(format: "%.2f", (rate * amount))
    }
    
    func amountControl(amount: String?) throws -> Double {
        guard let amount = amount, !amount.isEmpty else {
            throw AmountError.emptyAmount
        }
        
        guard let result = Double(amount) else {
            throw AmountError.incorrectAmount
        }
        
        return result
    }
}
