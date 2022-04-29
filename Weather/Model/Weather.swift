//
//  Weather.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import Foundation

struct Weather: Codable {
    
    let location: Location
    
    var forecast: Forecast
    
}

struct Location: Codable {
    
    let name: String
    
    let country: String
    
    let localtime: String
    
}

struct Forecast: Codable {
    
    var forecastday: [Forecastday]
    
}

struct Forecastday: Codable {
    
    let date: String
    
    var day: Day

}

struct Day: Codable {
    
    let maxtemp_c: Float
    
    let mintemp_c: Float
    
    var condition: Condition
    
}

struct Condition: Codable {
    
    let icon: String
    
    var image: Data?
    
}
