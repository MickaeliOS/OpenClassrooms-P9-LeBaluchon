//
//  TraductionService.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 09/11/2022.
//

import Foundation

class TraductionService {
    // Singleton
    static var shared = TraductionService()
    private init() {}

    // API configuration
    private static let baseURL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private var task: URLSessionDataTask?
    private var traductionSession = URLSession(configuration: .default)
    
    init(traductionSession: URLSession) {
        self.traductionSession = traductionSession
    }
    
    func getTraduction(source: String, target: String, text: String, callback: @escaping (Bool, String?, Error?) -> Void) {
        var request = URLRequest(url: TraductionService.baseURL)
        request.httpMethod = "POST"
        
        let body = """
            {
              "q": "\(text)",
              "source": "\(source)",
              "target": "\(target)",
              "format": "text"
            }
        """
        request.httpBody = body.data(using: .utf8)
        print(request)
        task?.cancel()
        
        task = traductionSession.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(TraductionResponse.self, from: data),
                      let traduction = responseJSON.data.translations[0].translatedText else {
                    callback(false, nil, nil)
                    return
                }
                
                callback(true, traduction, nil)
            }
        })
        task?.resume()
    }
}
