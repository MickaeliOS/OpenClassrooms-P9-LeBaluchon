//
//  TraductionTestsCase.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 17/11/2022.
//

import XCTest
@testable import LeBaluchon

final class TraductionTestsCase: XCTestCase {
    // MARK: - Variables
    var sessionFake: URLSession!
    var client: TraductionService!
    let source: String = "fr"
    let target: String = "en"
    let textToTranslate: String = "Bonjour, comment ça va ?"
    let expectedResponse = "Hi, how are you ?"
    var languageConfiguration: LanguageConfiguration!
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()

        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = TraductionService(traductionSession: sessionFake)
        
        // To test LanguageConfiguration's functions
        languageConfiguration = LanguageConfiguration()
    }
    
    // MARK: - API
    func testDataFetchedSuccessfully() {
        let dataFake = TraductionFakeResponseDataError.traductionCorrectData
        let responseFake = TraductionFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: textToTranslate) { success, result, error in
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
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: textToTranslate) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = TraductionFakeResponseDataError.traductionCorrectData
        let responseFake = TraductionFakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: textToTranslate) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfError() {
        let errorFake = TraductionFakeResponseDataError.error
        
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: textToTranslate) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTraductionShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = TraductionFakeResponseDataError.incorrectData
        let responseFake = TraductionFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (incorrectDataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getTraduction(source: source, target: target, text: textToTranslate) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Rest of the model
    func testGetSourceAndDestinationLanguagesShouldReturnTheGoodTupleIfLanguageIsFrench() {
        let (source, destination) = languageConfiguration.getSourceAndDestinationLanguages()
        XCTAssertEqual(source, "fr")
        XCTAssertEqual(destination, "en")
    }
    
    func testGetSourceAndDestinationLanguagesShouldReturnTheGoodTupleIfLanguageIsNotFrench() {
        languageConfiguration.sourceLanguage = "English"
        
        let (source, destination) = languageConfiguration.getSourceAndDestinationLanguages()
        XCTAssertEqual(source, "en")
        XCTAssertEqual(destination, "fr")
    }
    
    func testExchangeLanguageShouldSwitchLanguages() {
        languageConfiguration.exchangeLanguages()
        
        XCTAssertEqual(languageConfiguration.sourceLanguage, "English")
        XCTAssertEqual(languageConfiguration.destinationLanguage, "French")
        XCTAssertEqual(languageConfiguration.sourceFlag, "united_states_of_america_round_icon_64")
        XCTAssertEqual(languageConfiguration.destinationFlag, "france_round_icon_64")
    }
    
    func testEnglishChangingLanguageShouldExchangeLanguageIfNotFrench() {
        languageConfiguration.preferredLanguage = "en"
        languageConfiguration.englishChangingLanguage()
        
        XCTAssertEqual(languageConfiguration.sourceLanguage, "English")
        XCTAssertEqual(languageConfiguration.destinationLanguage, "French")
        XCTAssertEqual(languageConfiguration.sourceFlag, "united_states_of_america_round_icon_64")
        XCTAssertEqual(languageConfiguration.destinationFlag, "france_round_icon_64")
    }
    
    func testEnglishChangingLanguageShouldReturnIfNoPreferredLanguageIsFound() {
        languageConfiguration.preferredLanguage = nil
        languageConfiguration.englishChangingLanguage()
        
        // If the user don't have a preferred language, then we should have default configuration
        // which is the following one
        XCTAssertEqual(languageConfiguration.sourceLanguage, "French")
        XCTAssertEqual(languageConfiguration.destinationLanguage, "English")
        XCTAssertEqual(languageConfiguration.sourceFlag, "france_round_icon_64")
        XCTAssertEqual(languageConfiguration.destinationFlag, "united_states_of_america_round_icon_64")
    }
}
