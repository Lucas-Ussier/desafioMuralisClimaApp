//
//  MenuViewController.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 18/02/24.
//

import Foundation
import UIKit

class MenuViewController:UIViewController{
    let opt = ["Measurements", "Settings", "Logout"]
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Menu"
        
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        let defaults = UserDefaults.standard
        defaults.set("ºC", forKey: Weather.temperature.rawValue)
        defaults.set("mm", forKey: Weather.precipitation.rawValue)
        defaults.set("m/s", forKey: Weather.windSpeed.rawValue)
        defaults.set("hPa", forKey: Weather.pressure.rawValue)
        defaults.set("km", forKey: Weather.visibility.rawValue)
        
        defaults.synchronize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
}
extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        opt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = opt[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row){
        case 0:
            self.performSegue(withIdentifier: "MeasurementSegue", sender: nil)
            break
            
        case 1:
            performSegue(withIdentifier: "settingsSegue", sender: nil)
            break
            
        case 2:
            let alerta = UIAlertController(title: "",
                                           message: "You are logging out, do you want to continue?",
                                           preferredStyle: .alert)
            let sim = UIAlertAction(title: "Yes",
                                    style: .destructive) { action in
                self.navigationController?.popViewController(animated: true)
                NetworkServices.shared.resetToken()
            }
            let nao = UIAlertAction(title: "No", style: .cancel)
            alerta.addAction(sim)
            alerta.addAction(nao)
            present(alerta, animated: true)
            break
            
        default:
            print("Erro nao identificado")
            break
        }
    }
    
    
}
