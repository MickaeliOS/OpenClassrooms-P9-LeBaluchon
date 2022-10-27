//
//  ExchangeTestsCase.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 25/10/2022.
//

@testable import LeBaluchon
import XCTest

final class ExchangeTestsCase: XCTestCase {
    var sessionFake: URLSession!
    var client: ExchangeService!
    var to: String!
    var from: String!
    var amount: String!

    override func setUp() {
        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = ExchangeService(exchangeSession: sessionFake)
        
        // Default values for getExchangeRate()
        to = "USD"
        from = "EUR"
        amount = "200"
    }
    
    func testDataFetchedSuccessfully() {
        let dataFake = FakeResponseData.exchangeCorrectData
        let responseFake = FakeResponseData.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getExchangeRate(to: to, from: from, amount: amount) { success, result in
            XCTAssertTrue(success)
            
            // 202.761 is the exchange rate result i'm expected
            XCTAssertEqual(202.761, result)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfNoData() {
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getExchangeRate(to: to, from: from, amount: amount) { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = FakeResponseData.exchangeCorrectData
        let responseFake = FakeResponseData.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getExchangeRate(to: to, from: from, amount: amount) { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfError() {
        let errorFake = FakeResponseData.error
        
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getExchangeRate(to: to, from: from, amount: amount) { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = FakeResponseData.exchangeIncorrectData
        let responseFake = FakeResponseData.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, incorrectDataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getExchangeRate(to: to, from: from, amount: amount) { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
