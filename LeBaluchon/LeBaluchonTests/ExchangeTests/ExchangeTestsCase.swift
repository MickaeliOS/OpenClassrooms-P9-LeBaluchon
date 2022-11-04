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
    var from: String = "EUR"
    var to: String = "USD"
    var amount: String = "200"

    override func setUp() {
        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = ExchangeService(exchangeSession: sessionFake)
    }
    
    // MARK: - convert() tests
    
    func testDataFetchedSuccessfully() {
        let dataFake = FakeResponseDataError.convertCorrectData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.convert(from: from, to: to, amount: amount) { success, result, error  in
            // 202.761 is the exchange rate result i'm expected
            XCTAssertEqual(result, 202.761)
            XCTAssertTrue(success)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertShouldPostFailedCallbackIfNoData() {
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.convert(from: from, to: to, amount: amount) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = FakeResponseDataError.convertCorrectData
        let responseFake = FakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.convert(from: from, to: to, amount: amount) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertShouldPostFailedCallbackIfError() {
        let errorFake = FakeResponseDataError.error
        
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.convert(from: from, to: to, amount: amount) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testConvertShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = FakeResponseDataError.incorrectData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, incorrectDataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.convert(from: from, to: to, amount: amount) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - getLatestChangeRate() tests
    
    func testLatestChangeRateFetchedSuccessfully() {
        let dataFake = FakeResponseDataError.latestExchangeRateCorrectData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
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
        let errorFake = FakeResponseDataError.error

        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testLatestChangeRateShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = FakeResponseDataError.latestExchangeRateCorrectData
        let responseFake = FakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
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
        let incorrectDataFake = FakeResponseDataError.incorrectData
        let responseFake = FakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, incorrectDataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getLatestChangeRate(from: from, to: to) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
