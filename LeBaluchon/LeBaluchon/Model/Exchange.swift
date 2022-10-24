//
//  Exchange.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 20/10/2022.
//

import Foundation

struct Exchange: Decodable {
    var success: Bool
    var query: Query
    var info: Info
    var date: Date
    var result: Double?
}

struct Query: Decodable {
    var from: String
    var to: String
    var amount: Double
}

struct Info: Decodable {
    var timestamp: Int
    var rate: Double
}
