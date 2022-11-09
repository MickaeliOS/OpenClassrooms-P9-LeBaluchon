//
//  TraductionResponse.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 09/11/2022.
//

import Foundation

struct TraductionResponse: Decodable {
    var data: TraductionData
}

struct TraductionData: Decodable {
    var translations: [Translations]
}

struct Translations: Decodable {
    var translatedText: String?
}
