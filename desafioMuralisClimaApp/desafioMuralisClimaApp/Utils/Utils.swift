//
//  Utils.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 21/02/24.
//

import Foundation
import UIKit

enum Weather: String {
    case temperature = "temperature"
    case precipitation  = "precipitation"
    case humidity = "humidity"
    case windSpeed = "windSpeed"
    case windDirection = "windDirection"
    case pressure = "pressure"
    case visibility = "visibility"
    case date = "date"
    case changedAt = "changedAt"
}

class Utils{
    static func errorAlert(message: String,view: UIViewController, action: @escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: action)
        alert.addAction(ok)
        view.present(alert, animated: true)
    }
    
}
