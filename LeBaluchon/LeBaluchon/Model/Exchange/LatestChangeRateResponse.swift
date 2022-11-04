//
//  LatestChangeRateResponse.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 02/11/2022.
//

import Foundation

struct LatestChangeRateResponse: Decodable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: [String:Double]?
}
