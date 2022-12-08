//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var londonIcon: UIImageView!
    @IBOutlet weak var parisLabel: UILabel!
    @IBOutlet weak var londonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
    }
    
    private func getWeather() {
        WeatherService.shared.getWeather(city: "London") { success, tuple, error in
            if error != nil {
                //self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let (temperature, descriptions) = tuple, success == true else {
                return
            }
            
            self.londonLabel.text = "Il fait \(temperature) degrés, "
            
            descriptions.forEach { description in
                self.londonLabel.text! += description.key + ", "
            }

            self.londonLabel.text! += "à Londres."
        }
    }
    
    private func getIcon(iconNumber: String) {
        londonIcon.image = UIImage(named: "01d")
    }
}
