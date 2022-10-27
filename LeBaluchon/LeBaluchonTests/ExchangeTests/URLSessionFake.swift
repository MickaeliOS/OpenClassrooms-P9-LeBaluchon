//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by Mickaël Horn on 25/10/2022.
//

import Foundation

/* class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    override func cancel() {}
} */


final class MockURLProtocol: URLProtocol {
    
    // We return true in order to allow URLSession to use this
    // protocol for any URL Request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            print("Loading handler is not set.")
            return
        }
        
        let (response, data, error) = handler(request)
        
        guard error == nil else {
            client?.urlProtocol(self, didFailWithError: error!)
            return
        }
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
