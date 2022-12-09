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
        // London
        WeatherService.shared.getWeather(city: "New York") { success, tuple, error in
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
                
                // TODO: Comprendre le tableau weather
                self.getIcon(cityIcon: self.londonIcon, iconNumber: description.value)
            }

            self.londonLabel.text! += "à New York."
            
            // Paris
            WeatherService.shared.getWeather(city: "Paris") { success, tuple, error in
                if error != nil {
                    //self.presentAlert(with: error!.localizedDescription)
                    return
                }
                
                guard let (temperature, descriptions) = tuple, success == true else {
                    return
                }
                
                self.parisLabel.text = "Il fait \(temperature) degrés, "
                
                descriptions.forEach { description in
                    self.parisLabel.text! += description.key + ", "
                    
                    // TODO: Comprendre le tableau weather
                    self.getIcon(cityIcon: self.parisIcon, iconNumber: description.value)
                }

                self.parisLabel.text! += "à Paris."
            }
        }
    }
    
    private func getIcon(cityIcon: UIImageView, iconNumber: String) {
        cityIcon.image = UIImage(named: iconNumber)
    }
}
