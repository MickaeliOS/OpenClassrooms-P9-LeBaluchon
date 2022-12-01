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

    // API configuration
    private static let baseURL = URLComponents(string: "https://api.apilayer.com/fixer")!
    private var task: URLSessionDataTask?
    private var exchangeSession = URLSession(configuration: .default)
    
    init(exchangeSession: URLSession) {
        self.exchangeSession = exchangeSession
    }
    
    func convert(from: String, to: String, amount: String, callback: @escaping (Bool, Double?, Error?) -> Void) {
        // We prepare the parameters to be added at our baseUrl
        let from = URLQueryItem(name: "from", value: from)
        let to = URLQueryItem(name: "to", value: to)
        let amount = URLQueryItem(name: "amount", value: amount)
        let request = getCompleteRequest(endPoints: "/convert", parameters: [to, from, amount])
                
        task?.cancel()
        task = exchangeSession.dataTask(with: request) { data, response, error in
            // The dataTask method will execute in a separate queue, so we get back into the main one because
            // we will modify the user interface with our exchange result
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("PREMIERE BOUCLE")
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("DEUXIEME BOUCLE")
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(ConvertResponse.self, from: data),
                      let result = responseJSON.result else {
                    callback(false, nil, nil)
                    return
                }
                callback(true, result, nil)
            }
        }
        task?.resume()
    }
    
    func getLatestChangeRate(from: String, to: String, callback: @escaping (Bool, Double?, Error?) -> Void) {
        // Base = the three-letter currency code of your preferred base currency
        // Symbols = the output currency
        let base = URLQueryItem(name: "base", value: from)
        let symbols = URLQueryItem(name: "symbols", value: to)
        let request = getCompleteRequest(endPoints: "/latest", parameters: [base, symbols])
        
        // task?.cancel()
        // Dans le controller, on appelle deux fois cette fonction
        // Pourquoi ça marche sachant qu'on enlève task?.cancel() ?
        // C'est à dire que task va être écrasée par le deuxième appel mais les deux appels fonctionnent très bien
        task = exchangeSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(LatestChangeRateResponse.self, from: data),
                      let rates = responseJSON.rates else {
                    callback(false, nil, nil)
                    return
                }
                
                callback(true, rates[to], nil)
            }
        }
        // print(task)
        task?.resume()
    }
    
    private func getCompleteRequest(endPoints: String, parameters: [URLQueryItem]) -> URLRequest {
        var completeUrl = ExchangeService.baseURL
        completeUrl.path.append(endPoints)
        completeUrl.queryItems = parameters
        print(completeUrl)
        var request = URLRequest(url: completeUrl.url!)
        request.addValue(APIKeys.apiLayerKey.rawValue, forHTTPHeaderField: "apikey")
        
        return request
    }
    
    /* func getSymbols(callback: @escaping (Bool, [String]?, Error?) -> Void) {
        let completeUrl = ExchangeService.baseURL.appending(path: "/symbols")
        var request = URLRequest(url: completeUrl)
        request.addValue(APIKeys.apiLayerKey.rawValue, forHTTPHeaderField: "apikey")
        
        task?.cancel()
        
        task = exchangeSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(SymbolsResponse.self, from: data),
                      let result = responseJSON.symbols else {
                    callback(false, nil, nil)
                    return
                }
                callback(true, result, nil)
            }
        }
        task?.resume()
    } */
}
