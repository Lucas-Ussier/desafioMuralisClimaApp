//
//  WeatherEntry.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 22/02/24.
//

import Foundation

struct WeatherEntry: Codable {
    let id: String
    let temperature: Double
    let precipitation: Double
    let date: String
    let weatherCondition: String
    
    enum CodingKeys: String, CodingKey{
        case id, temperature, precipitation, date
        case weatherCondition = "weather_condition"
    }
}
