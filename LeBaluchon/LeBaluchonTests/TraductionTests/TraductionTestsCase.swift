//
//  TraductionTestsCase.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 17/11/2022.
//

import XCTest
@testable import LeBaluchon

final class TraductionTestsCase: XCTestCase {
    var sessionFake: URLSession!
    var client: TraductionService!
    let source: String = "fr"
    let target: String = "en"
    let text: String = "Bonjour, comment ça va ?"
    let expectedResponse = "Hi, how are you ?"

    override func setUp() {
        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = TraductionService(traductionSession: sessionFake)
    }
    
    func testDataFetchedSuccessfully() {
        let dataFake = TraductionFakeResponseDataError.traductionCorrectData
        let responseFake = TraductionFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: text) { success, result, error in
            XCTAssertTrue(success)
            XCTAssertEqual(result, self.expectedResponse)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfNoData() {
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: text) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = ExchangeFakeResponseDataError.convertCorrectData
        let responseFake = ExchangeFakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, dataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: text) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfError() {
        let errorFake = ExchangeFakeResponseDataError.error
        
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: text) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = ExchangeFakeResponseDataError.incorrectData
        let responseFake = ExchangeFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (responseFake, incorrectDataFake, nil)
        }
        
        setUp()
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: text) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
