//
//  weatherResponse.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import Foundation

struct weatherResponse: Decodable {
    var coord: Coord
    var weather: [WeatherInformations]?
    var base: String
    var main: Main
    var visibility: Int
    var wind: Wind
    var clouds: Clouds
    var dt: Int
    var sys: Sys
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int
}

struct Coord: Decodable {
    var lon: Double
    var lat: Double
}

struct WeatherInformations: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Decodable {
    var temp: Double?
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Decodable {
    var speed: Double
    var deg: Int
}

struct Clouds: Decodable {
    var all: Int
}

struct Sys: Decodable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: Int
    var sunset: Int
}
