//
//  ExchangeResponse.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 02/11/2022.
//

import Foundation

struct ExchangeResponse: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String:Double]?
}
