//
//  ExchangeFakeResponseDataError.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 25/10/2022.
//

import Foundation

class ExchangeFakeResponseDataError {
    // Data - convert()
    static var convertCorrectData: Data {
        let bundle = Bundle(for: ExchangeFakeResponseDataError.self)
        let url = bundle.url(forResource: "Convert", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    // Data - latestExchangeRate()
    static var latestExchangeRateCorrectData: Data {
        let bundle = Bundle(for: ExchangeFakeResponseDataError.self)
        let url = bundle.url(forResource: "LatestChangeRate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    // Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // Error
    class ExchangeError: Error {}
    static let error = ExchangeError()
}
