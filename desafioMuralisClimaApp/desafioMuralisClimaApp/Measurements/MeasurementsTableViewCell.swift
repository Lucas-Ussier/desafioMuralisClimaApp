//
//  MeasurementsTableViewCell.swift
//  desafioMuralisClimaApp
//
//  Created by Lucas Galvao on 21/02/24.
//

import UIKit

class MeasurementsTableViewCell: UITableViewCell {
    static let identifier = "MeasurementsTableViewCell"

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureView(temp: String, prec: String, hour: String, weatherConditionText: String, weatherConditionImage: String){
        self.selectionStyle = .none
        self.weatherConditionImageView.tintColor = .accent
        self.temperatureLabel.text = temp
        self.precipitationLabel.text = prec
        self.hourLabel.text = hour
        self.weatherConditionLabel.text = weatherConditionText
        self.weatherConditionImageView.image = UIImage(systemName: weatherConditionImage)
    }
    
}
