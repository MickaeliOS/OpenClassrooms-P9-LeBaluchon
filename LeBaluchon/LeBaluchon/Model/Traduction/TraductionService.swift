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
    // The Google Translation API need to get his API Key in the URL, we can't pass it from the Header
    private static let baseURL = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(APIKeys.googleTranslationKey.rawValue)")!
    private var task: URLSessionDataTask?
    private var traductionSession = URLSession(configuration: .default)
    
    init(traductionSession: URLSession) {
        self.traductionSession = traductionSession
    }
    
    func getTraduction(source: String, target: String, text: String, callback: @escaping (Bool, String?, Error?) -> Void) {
        let request = getCompleteRequest(source: source, target: target, text: text)
        task?.cancel()
        
        task = traductionSession.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, !data.isEmpty, error == nil else {
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
    
    private func getCompleteRequest(source: String, target: String, text: String) -> URLRequest {
        var request = URLRequest(url: TraductionService.baseURL)
        request.httpMethod = "POST"
        
        // The request's body is a JSON and we need the good format
        let jsonBody = ["q": "\(text)",
                        "source": "\(source)",
                        "target": "\(target)",
                        "format": "text"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted)
 
        // Since the body is a JSON, we need the request to accept this format
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
}
