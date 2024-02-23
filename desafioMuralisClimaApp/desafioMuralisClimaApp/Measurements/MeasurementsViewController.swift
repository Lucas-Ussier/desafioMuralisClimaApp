//
//  MeasurementsViewController.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 18/02/24.
//

import Foundation
import UIKit
import UIScrollView_InfiniteScroll

class MeasurementsViewController: UIViewController{
    
    @IBOutlet weak var footerview: UIView!
    @IBOutlet weak var measurementTableView: UITableView!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    let model: MeasurementsViewModel = MeasurementsViewModel()
    let network = NetworkServices.shared
    let defaults = UserDefaults.standard
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Measurements"
        
        measurementTableView.register(UINib(nibName: "MeasurementsTableViewCell", bundle: nil), forCellReuseIdentifier: MeasurementsTableViewCell.identifier)
        measurementTableView.dataSource = self
        measurementTableView.delegate = self
        
        measurementTableView.infiniteScrollDirection = .vertical
        
        self.network.getMeasurements(page: 0, pageSize: 50) { result in
            switch result {
            case .success(let success):
                self.model.setDataBase(data: success)
                DispatchQueue.main.async{
                    self.model.setup(tableView: self.measurementTableView)
                    self.measurementTableView.reloadData()
                    self.totalCountLabel.text = "\(self.model.getTotalCount()) itens"
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        measurementTableView.addInfiniteScroll { tableView in
            
            self.network.getMeasurements(page: self.page, pageSize: 50) { result in
                switch result {
                case .success(let success):
                    self.model.setDataBase(data: success)
                    if(NetworkServices.shared.getTotalCount() > (self.page*50)){
                        self.page+=1
                    }else{
                        print("Total Atingido")
                    }
                    DispatchQueue.main.async{
                        self.model.setup(tableView: self.measurementTableView)
                        self.measurementTableView.reloadData()
                        self.measurementTableView.finishInfiniteScroll()
                        self.totalCountLabel.text = "\(self.model.getTotalCount()) itens"
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        
    }

}

extension MeasurementsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        self.model.getSeparatedData().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = model.getSortedDates()[section]
        return model.getSeparatedData()[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementsTableViewCell.identifier, for: indexPath) as? MeasurementsTableViewCell
        
        let date = model.getSortedDates()[indexPath.section]
        if let entriesForDate = model.getSeparatedData()[date] {
            let entry = entriesForDate[indexPath.row]
            guard let tempUnity = defaults.string(forKey: Weather.temperature.rawValue) else {return UITableViewCell()}
            guard let precUnity = defaults.string(forKey: Weather.precipitation.rawValue) else {return UITableViewCell()}
            
            cell?.configureView(temp: "\(entry.temperature) \(tempUnity)",
                                prec: "\(entry.precipitation) \(precUnity)",
                                hour: "\(entry.date[entry.date.index(entry.date.startIndex, offsetBy: 11)..<entry.date.index(entry.date.startIndex, offsetBy: 16)])",
                                weatherConditionText: entry.weatherCondition,
                                weatherConditionImage: model.getWeatherImageName(weatherCondition: entry.weatherCondition))
            cell?.selectionStyle = .none
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getSortedDates()[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = model.getSortedDates()[indexPath.section]
        if let entriesForDate = model.getSeparatedData()[date] {
            let entry = entriesForDate[indexPath.row]
            
            model.getDetails(at: entry.id)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                if(self.network.getisError()){
                    Utils.errorAlert(message: "Internal Server Error please try again later",
                                     view: self) { action in
                        print("")
                    }
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ,
                                                  execute: {
                        self.performSegue(withIdentifier: "DetailsSegue", sender: nil)
                    })
                }
            }
        }
    }
}
