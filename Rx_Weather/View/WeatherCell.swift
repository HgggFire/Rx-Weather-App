//
//  WeatherCell.swift
//  Rx_Weather
//
//  Created by LinChico on 2/2/18.
//  Copyright © 2018 RJTCompuquest. All rights reserved.
//

import UIKit
import Cards

class WeatherCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var cellCardView: CardHighlight!
    @IBOutlet weak var dateCardView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        windImageView.image = windImageView.image?.withRenderingMode(.alwaysTemplate)
        
        
        dateCardView.layer.cornerRadius = 5
        cellCardView.layer.cornerRadius = 10
        
        self.contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
        
        cellCardView.layer.masksToBounds = false
        cellCardView.layer.shadowColor = UIColor.black.cgColor
        cellCardView.layer.shadowOpacity = 0.7
        cellCardView.layer.shadowOffset = CGSize(width: 5, height: -5)
        cellCardView.layer.shadowRadius = 1
        
//        cellCardView.layer.shadowPath = UIBezierPath(rect: cellCardView.bounds).cgPath
        cellCardView.layer.shouldRasterize = true
        cellCardView.layer.rasterizationScale = UIScreen.main.scale
        
//        cellCardView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var weatherModel: ForecastWeather? {
        didSet{
            tempLabel.text = String(format: "%.0f ℃", weatherModel!.temperature)
            dateLabel.text = weatherModel?.date
            descriptionLabel.text = weatherModel?.description
            weatherImageView.image = UIImage(named: weatherModel!.condition.title)
            windLabel.text = String(format: "%.0f mps", (weatherModel?.wind)!)
            
        }
    }

}
