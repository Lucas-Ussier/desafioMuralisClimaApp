//
//  WeatherDescripition.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 22/02/24.
//

import Foundation


struct WeatherDescription: Codable{
    let id: String
    let temperature: Double
    let precipitation: Double
    let humidity: Double
    let windSpeed: Double
    let windDirection: Double
    let pressure: Double
    let visibility: Double
    let date: String
    let changedAt: String
    let weatherCondition: String
    
    enum CodingKeys: String, CodingKey{
        case id, temperature, precipitation, humidity, pressure, visibility, date
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case changedAt = "changed_at"
        case weatherCondition = "weather_condition"
    }
}
