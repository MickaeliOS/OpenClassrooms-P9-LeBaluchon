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
    
    // We return true in order to allow URLSession to use this protocol for any URL Request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (Data?, HTTPURLResponse?, Error?))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            print("Loading handler is not set.")
            return
        }
        
        let (data, response, error) = handler(request)
        
        // I'm forced to return didFailWithError when data is nil, because if I don't,
        // when the startLoading() function terminates, data will be at 0 bytes by default
        /*guard data != nil, error == nil else {
            client?.urlProtocol(self, didFailWithError: error!)
            return
        }*/
        
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


/* class MockURLProtocol: URLProtocol {
    static var loadingHandler: ((URLRequest) throws -> (Data?, HTTPURLResponse?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {}
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            return
        }
        
        do {
            let (data, response, error) = try handler(request)
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data!)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
} */

/* class MockURLProtocol: URLProtocol {
 static var loadingHandler: ((URLRequest) throws -> (Data?, HTTPURLResponse?, Error?))?
 
 override class func canInit(with request: URLRequest) -> Bool {
     return true
 }
 
 override class func canonicalRequest(for request: URLRequest) -> URLRequest {
     return request
 }
 
 override func stopLoading() {}
 
 override func startLoading() {
     guard let handler = MockURLProtocol.loadingHandler else {
         return
     }
     
     do {
         let (data, response, error) = try handler(request)
         
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
     } catch {
         client?.urlProtocol(self, didFailWithError: error)
     }
 }
}*/
