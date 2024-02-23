//
//  MeasurementsDteailsViewController.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 19/02/24.
//

import Foundation
import UIKit

class MeasurementsDteailsViewController: UITableViewController{
    
    @IBOutlet weak var wheatherConditionIndicatorImageView: UIImageView!
    @IBOutlet weak var changedAtLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let model: MeasurementsViewModel = MeasurementsViewModel()
    let network = NetworkServices.shared
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.network.detailsReloadDelegate = self
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.setupView()
            self.tableView.reloadData()
        })
    }
    
    func setupView() {
        let details = self.network.getDetails()
        
        self.changedAtLabel.numberOfLines = 0
        self.dateLabel.numberOfLines = 0
        
        let visibility: String = String(details.visibility)
        let pressure: String = String(details.pressure)
        let windDirection: String = String(details.windDirection)
        let windSpeed: String = String(details.windSpeed)
        let humidity: String = String(details.humidity)
        let precipitation: String = String(details.precipitation)
        let temperature: String = String(details.temperature)
        var changedAtFormatted = ""
        var dateFormatted = ""
        let weatherCondition = details.weatherCondition
        
        if(!details.date.isEmpty){
            changedAtFormatted = "\( details.changedAt[..<details.changedAt.index(details.changedAt.startIndex, offsetBy: 10)]) \n \(details.changedAt[details.changedAt.index(details.changedAt.startIndex, offsetBy: 10)...])"
            dateFormatted = "\( details.date[..<details.date.index(details.date.startIndex, offsetBy: 10)]) \n \(details.date[details.date.index(details.date.startIndex, offsetBy: 10)...])"
        }
        
        guard let temperatureUnity = defaults.string(forKey: Weather.temperature.rawValue) else {return}
        guard let precipitationUnity = defaults.string(forKey: Weather.precipitation.rawValue) else {return}
        guard let windSpeedUnity = defaults.string(forKey: Weather.windSpeed.rawValue) else {return}
        guard let pressureUnity = defaults.string(forKey: Weather.pressure.rawValue) else {return}
        guard let visibilityUnity = defaults.string(forKey: Weather.visibility.rawValue) else {return}
        
        self.changedAtLabel.text = "\(changedAtFormatted)"
        self.dateLabel.text = "\(dateFormatted)"
        
        self.visibilityLabel.text = "\(visibility) \(visibilityUnity)"
        self.pressureLabel.text = "\(pressure) \(pressureUnity)"
        self.windDirectionLabel.text = "\(windDirection)"
        self.windSpeedLabel.text = "\(windSpeed) \(windSpeedUnity)"
        self.humidityLabel.text = "\(humidity)"
        self.precipitationLabel.text = "\(precipitation) \(precipitationUnity)"
        self.temperatureLabel.text = "\(temperature) \(temperatureUnity)"
        self.wheatherConditionIndicatorImageView.image = UIImage(systemName: model.getWeatherImageName(weatherCondition: weatherCondition))
    }
}

extension MeasurementsDteailsViewController: DetailsReloadTableProtocol{
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    
}
