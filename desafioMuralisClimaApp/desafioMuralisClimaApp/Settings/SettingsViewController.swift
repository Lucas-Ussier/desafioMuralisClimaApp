//
//  SettingsViewController.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 21/02/24.
//

import Foundation
import UIKit
import UIScrollView_InfiniteScroll

class SettingsViewController:UIViewController{
    
    @IBOutlet weak var visibilityButton: UIButton!
    @IBOutlet weak var pressureButton: UIButton!
    @IBOutlet weak var windSpeedButton: UIButton!
    @IBOutlet weak var precipitationButton: UIButton!
    @IBOutlet weak var temperatureButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        setupMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSettings()
    }
    
    func setupMenu(){
        let buttons = [temperatureButton, visibilityButton, pressureButton, windSpeedButton, precipitationButton]
        
        for button in buttons {
            button?.showsMenuAsPrimaryAction = true
            button?.changesSelectionAsPrimaryAction = true
        }
        
        let tempAction = {(act: UIAction) in
            self.updateTitle(button: self.temperatureButton, title: act.title)
        }
        
        let temp: [UIAction] = [UIAction(title: "ºC", handler: tempAction), UIAction(title: "ºF", handler: tempAction)]
        
        let precAction = {(act: UIAction) in
            self.updateTitle(button: self.precipitationButton, title: act.title)
        }
        
        let prec: [UIAction] = [UIAction(title: "mm", handler: precAction), UIAction(title: "in", handler: precAction)]
        
        let windSpeedAction = {(act: UIAction) in
            self.updateTitle(button: self.windSpeedButton, title: act.title)
        }
        
        let windSpeed: [UIAction] = [UIAction(title: "m/s", handler: windSpeedAction), UIAction(title: "km/h", handler: windSpeedAction)]
        
        let pressureAction = {(act: UIAction) in
            self.updateTitle(button: self.pressureButton, title: act.title)
        }
        
        let pressure: [UIAction] = [UIAction(title: "hPa", handler: pressureAction), UIAction(title: "inHg", handler: pressureAction)]
        
        let visibilityAction = {(act: UIAction) in
            self.updateTitle(button: self.visibilityButton, title: act.title)
        }
        
        let visibility: [UIAction] = [UIAction(title: "km", handler: visibilityAction), UIAction(title: "mi", handler: visibilityAction)]
        
        temperatureButton.menu = UIMenu(children: temp)
        precipitationButton.menu = UIMenu(children: prec)
        windSpeedButton.menu = UIMenu(children: windSpeed)
        pressureButton.menu = UIMenu(children: pressure)
        visibilityButton.menu = UIMenu(children: visibility)
    }
    
    func updateTitle(button: UIButton, title: String?){
        button.setTitle(title, for: .normal)
    }
    
    func saveSettings(){
        let temp = self.temperatureButton.titleLabel?.text
        let precipitation = self.precipitationButton.titleLabel?.text
        let windSpeed = self.windSpeedButton.titleLabel?.text
        let pressure = self.pressureButton.titleLabel?.text
        let visibility = self.visibilityButton.titleLabel?.text
        
        
        defaults.set(temp, forKey: Weather.temperature.rawValue)
        defaults.set(precipitation, forKey: Weather.precipitation.rawValue)
        defaults.set(windSpeed, forKey: Weather.windSpeed.rawValue)
        defaults.set(pressure, forKey: Weather.pressure.rawValue)
        defaults.set(visibility, forKey: Weather.visibility.rawValue)
        
        defaults.synchronize()
    }
    
    func loadSettings(){
        self.temperatureButton.setTitle(defaults.string(forKey: Weather.temperature.rawValue), for: .normal)
        self.precipitationButton.setTitle(defaults.string(forKey: Weather.precipitation.rawValue), for: .normal)
        self.windSpeedButton.setTitle(defaults.string(forKey: Weather.windSpeed.rawValue), for: .normal)
        self.pressureButton.setTitle(defaults.string(forKey: Weather.pressure.rawValue), for: .normal)
        self.visibilityButton.setTitle(defaults.string(forKey: Weather.visibility.rawValue), for: .normal)
    }
}
