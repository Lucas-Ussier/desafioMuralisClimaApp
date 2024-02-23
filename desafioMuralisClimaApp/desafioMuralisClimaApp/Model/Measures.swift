//
//  Measures.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 22/02/24.
//

import Foundation

struct Measures: Codable{
    var totalCount: Int
    var data: [WeatherEntry]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case data
    }
}
    
