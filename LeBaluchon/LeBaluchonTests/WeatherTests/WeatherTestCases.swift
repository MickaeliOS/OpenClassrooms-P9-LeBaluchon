//
//  WeatherTestCases.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 24/11/2022.
//

@testable import LeBaluchon
import XCTest

final class WeatherTestCases: XCTestCase {
    // MARK: - Variables
    var sessionFake: URLSession!
    var client: WeatherService!
    var city = "Paris"
    var weather: WeatherSupport!
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()

        // Mocking URLProtocol
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionFake = URLSession(configuration: configuration)
        client = WeatherService(weatherSession: sessionFake)
        
        // To test WeatherSupport's functions
        weather = WeatherSupport()
    }
    
    // MARK: - API
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
            XCTAssertEqual(temperature, 9.44)
            XCTAssertEqual(descriptions["nuageux"], "04d")
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
    
    // MARK: - Rest of the model
    func testRoundedTemperatureShouldRoundToTheNearestInteger() {
        let temperature = 21.86
        let roundedTemperature = weather.roundedTemperature(temperature: temperature)
        XCTAssertEqual(roundedTemperature, "22")
    }
    
    func testRemoveLineBreakShouldRemoveTheLineBreak() {
        let lineBreakString = "example\n"
        let result = weather.removeLineBreak(from: lineBreakString)
        
        XCTAssertEqual(result, "example")
    }
    
    func testRemoveLineBreakShouldReturnIfStringIsNil() {
        let result = weather.removeLineBreak(from: nil)
        
        XCTAssertEqual(result, nil)
    }
}
