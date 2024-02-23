//
//  MeasurementsViewModel.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 21/02/24.
//

import Foundation
import UIKit

class MeasurementsViewModel{
    private let network = NetworkServices.shared
    private let defaults = UserDefaults.standard
    
    private var separatedData: [String: [WeatherEntry]] = [:]
    private var sortedDates: [String] = []
    
    private var page = 1
    private var pageLimit = 50
    private var totalCount = 0
    
    private var dataBase = [WeatherEntry]()
    
    public func setDataBase(data: [WeatherEntry]){
        self.dataBase.append(contentsOf: data)
    }
    
    public func setup(tableView: UITableView){
        
        separatedData = network.getEntryByDate(self.dataBase)
        sortedDates = Array(separatedData.keys).sorted()
        
        tableView.reloadData()
    }
    
    public func getTotalCount() -> String{
        return network.getTotalCount()
    }
    
    public func getSeparatedData() -> [String: [WeatherEntry]]{
        return separatedData
    }
    
    public func getSortedDates() -> [String]{
        return sortedDates
    }
    
    public func getDefaults(key: String) -> String{
        guard let string = self.defaults.string(forKey: key) else {return ""}
        return string
    }
    
    public func getDetails(at id: String){
        network.setId(id: id)
        network.getMeasurementsDetails(at: id)
    }
    
    public func getWeatherImageName(weatherCondition: String) -> String{
        switch weatherCondition.lowercased() {
        case "cloudy":
            return "cloud.circle"
        case "rain":
            return "cloud.rain.circle"
        case "clear":
            return "sun.max.circle"
        default:
            return "snowflake.circle"
        }
    }
    
    
}
