//
//  WeatherTestCases.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 24/11/2022.
//

@testable import LeBaluchon
import XCTest

final class WeatherTestCases: XCTestCase {
    var sessionFake: URLSession!
    var client: WeatherService!
    var city = "London"
    
    override func setUp() {
        super.setUp()

        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = WeatherService(weatherSession: sessionFake)
    }
    
    func testDataFetchedSuccessfully() {
        let dataFake = WeatherFakeResponseDataError.weatherCorrectData
        let responseFake = WeatherFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getWeather(city: city) { success, result, error in
            XCTAssertTrue(success)
            
            guard let (temperature, descriptions) = result else {
                return
            }
            XCTAssertEqual(temperature, 7.43)
            XCTAssertEqual(descriptions["ciel dégagé"], "01d")
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getWeather(city: city) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        let dataFake = WeatherFakeResponseDataError.weatherCorrectData
        let responseFake = WeatherFakeResponseDataError.responseKO
        
        MockURLProtocol.loadingHandler = { request in
            return (dataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getWeather(city: city) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        let errorFake = WeatherFakeResponseDataError.error
        
        MockURLProtocol.loadingHandler = { request in
            return (nil, nil, errorFake)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getWeather(city: city) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        let incorrectDataFake = WeatherFakeResponseDataError.incorrectData
        let responseFake = WeatherFakeResponseDataError.responseOK
        
        MockURLProtocol.loadingHandler = { request in
            return (incorrectDataFake, responseFake, nil)
        }
                
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        client.getWeather(city: city) { success, result, error in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
