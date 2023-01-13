//
//  ExchangeTestsCase.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 25/10/2022.
//

import XCTest
@testable import LeBaluchon

final class ExchangeTestsCase: XCTestCase {
    var sessionFake: URLSession!
    var client: ExchangeService!
    var from: String = "EUR"
    var to: String = "USD"
    var amount: String = "200"

    override func setUp() {
        super.setUp()
        
        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = ExchangeService(exchangeSession: sessionFake)
    }

    func testLatestChangeRateFetchedSuccessfully() {
        let dataFake = ExchangeFakeResponseDataError.latestExchangeRateCorrectData
        let responseFake = ExchangeFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            // 0.977761 is the exchange rate result i'm expected
            XCTAssertEqual(result, 0.977761)
            XCTAssertTrue(success)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLatestChangeRateShouldPostFailedCallbackIfNoData() {
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLatestChangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = ExchangeFakeResponseDataError.latestExchangeRateCorrectData
        let responseFake = ExchangeFakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLatestChangeRateShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = ExchangeFakeResponseDataError.incorrectData
        let responseFake = ExchangeFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (incorrectDataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertCurrencyShouldSuccesIfRateAndAmountAreCorrectlyProvided() {
        Exchange.rate = 1.02
        
        do {
            let result = try Exchange.convertCurrency(amount: 21)
            XCTAssertEqual(result, "21.42")
        } catch {
            XCTFail("An unexpected error occured: \(error)")
        }
        
        // In the next test case, I must not have any exchange rate
        Exchange.rate = nil
    }

    func testConvertCurrencyShouldThrowErrorIfRateIsNotSet() {
        XCTAssertThrowsError(try Exchange.convertCurrency(amount: 21)) { (error) in
            if let error = error as? Exchange.CurrencyError {
                XCTAssertEqual(error, .unknownRate)
                XCTAssertEqual(error.localizedDescription, "Unknown exchange rate, please refresh it.")
            } else {
                XCTFail("An unexpected error occurred: \(error)")
            }
        }
    }
}
