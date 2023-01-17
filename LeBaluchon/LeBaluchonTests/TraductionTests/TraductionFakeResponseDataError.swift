//
//  TraductionFakeResponseDataError.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 17/11/2022.
//

import Foundation

class TraductionFakeResponseDataError {
    // Data
    static var traductionCorrectData: Data {
        let bundle = Bundle(for: TraductionFakeResponseDataError.self)
        let url = bundle.url(forResource: "Traduction", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    
    // Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // Error
    class TraductionError: Error {}
    static let error = TraductionError()
}
