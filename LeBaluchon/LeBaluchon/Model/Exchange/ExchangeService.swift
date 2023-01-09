//
//  ExchangeService.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 20/10/2022.
//

import Foundation

class ExchangeService {
    // Singleton
    static var shared = ExchangeService()
    private init() {}
    
    // Save the current rate
    var rate: Double?

    // API configuration
    private static let baseURL = URLComponents(string: "https://api.apilayer.com/fixer")!
    private var task: URLSessionDataTask?
    private var exchangeSession = URLSession(configuration: .default)
    
    init(exchangeSession: URLSession) {
        self.exchangeSession = exchangeSession
    }
    
    func getLatestChangeRate(from: String, to: String, callback: @escaping (Bool, Double?, Error?) -> Void) {
        // Base = the three-letter currency code of your preferred base currency
        // Symbols = the output currency
        let base = URLQueryItem(name: "base", value: from)
        let symbols = URLQueryItem(name: "symbols", value: to)
        let request = getCompleteRequest(endPoints: "/latest", parameters: [base, symbols])
        
        task?.cancel()
        task = exchangeSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, !data.isEmpty, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(ExchangeResponse.self, from: data),
                      let rates = responseJSON.rates else {
                    callback(false, nil, nil)
                    return
                }
                
                callback(true, rates[to], nil)
            }
        }
        task?.resume()
    }
    
    private func getCompleteRequest(endPoints: String, parameters: [URLQueryItem]) -> URLRequest {
        var completeUrl = ExchangeService.baseURL
        completeUrl.path.append(endPoints)
        completeUrl.queryItems = parameters
        var request = URLRequest(url: completeUrl.url!)
        request.addValue(APIKeys.apiLayerKey.rawValue, forHTTPHeaderField: "apikey")
        
        return request
    }
}
