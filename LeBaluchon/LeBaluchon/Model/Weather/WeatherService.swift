//
//  weatherService.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import Foundation

class WeatherService {
    // Singleton
    static var shared = WeatherService()
    private init() {}

    // API configuration
    private static let baseURL = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    
    func getWeather(city: String, callback: @escaping (Bool, (Double, [String:String])?, Error?) -> Void) {
        let city = URLQueryItem(name: "q", value: city)
        let lang = URLQueryItem(name: "lang", value: "fr")
        let units = URLQueryItem(name: "units", value: "metric") // For Celsius
        let apiKey = URLQueryItem(name: "appid", value: APIKeys.openWeatherMapKey.rawValue)
        let request = getCompleteRequest(parameters: [city, lang, units, apiKey])
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { data, response, error in
            // The dataTask method will execute in a separate queue, so we get back into the main one because
            // we will modify the user interface with our exchange result
            DispatchQueue.main.async {
                guard let data = data, !data.isEmpty, error == nil else {
                    callback(false, nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(weatherResponse.self, from: data),
                      let temperature = responseJSON.main.temp, let weather = responseJSON.weather else {
                    callback(false, nil, nil)
                    return
                }
                
                let descriptions = self.getWeatherInformations(weather: weather)
                callback(true, (temperature, descriptions), nil)
            }
        }
        task?.resume()
    }
    
    private func getCompleteRequest(parameters: [URLQueryItem]) -> URLRequest {
        var completeUrl = WeatherService.baseURL
        completeUrl.queryItems = parameters
        let request = URLRequest(url: completeUrl.url!)
        
        return request
    }
    
    private func getWeatherInformations(weather: [WeatherInformations]) -> [String:String] {
        var descriptions = [String:String]()
        
        weather.forEach { weather in
            descriptions[weather.description] = weather.icon
        }
        
        return descriptions
    }
}
