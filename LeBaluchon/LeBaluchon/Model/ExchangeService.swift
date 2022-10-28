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
    
    private static let baseURL = URL(string: "https://api.apilayer.com/fixer/convert")!
    private var task: URLSessionDataTask?
    private var exchangeSession = URLSession(configuration: .default)
    
    init(exchangeSession: URLSession) {
        self.exchangeSession = exchangeSession
    }
    
    func getExchangeRate(from: String, to: String, amount: String, callback: @escaping (Bool, Double?, Error?) -> Void) {
        // We prepare the parameters to be added at our baseUrl
        let from = URLQueryItem(name: "from", value: from)
        let to = URLQueryItem(name: "to", value: to)
        let amount = URLQueryItem(name: "amount", value: amount)
        
        // Adding parameters
        let completeUrl = ExchangeService.baseURL.appending(queryItems: [to, from, amount])
        var request = URLRequest(url: completeUrl)
        request.addValue(APIKeys.ApiLayerKey.rawValue, forHTTPHeaderField: "apikey")
                
        task?.cancel()
        task = exchangeSession.dataTask(with: request) { data, response, error in
            // The dataTask method will execute in a separate queue, so we get back into the main one because
            // we will modify the user interface with our exchange result
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(Exchange.self, from: data),
                      let result = responseJSON.result else {
                    callback(false, nil, nil)
                    return
                }
                callback(true, result, nil)
            }
        }
        task?.resume()
    }
}
