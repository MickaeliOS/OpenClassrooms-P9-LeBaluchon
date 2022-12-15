//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var parisTitle: UILabel!
    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var parisTemp: UILabel!
    @IBOutlet weak var parisMeteoDescription: UILabel!
    
    @IBOutlet weak var newYorkTitle: UILabel!
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var newYorkTemp: UILabel!
    @IBOutlet weak var newYorkMeteoDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getWeather()
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
            
            self.newYorkTemp.text = "\(temperature) °C"
            self.newYorkMeteoDescription.text = ""
            
            descriptions.forEach { description in
                self.newYorkMeteoDescription.text! += description.key + ", "
                
                // TODO: Comprendre le tableau weather
                self.getIcon(cityIcon: self.newYorkIcon, iconNumber: description.value)
            }
            
            // Paris
            WeatherService.shared.getWeather(city: "Paris") { success, tuple, error in
                if error != nil {
                    //self.presentAlert(with: error!.localizedDescription)
                    return
                }
                
                guard let (temperature, descriptions) = tuple, success == true else {
                    return
                }
                
                self.parisTemp.text = "\(temperature) °C"
                self.parisMeteoDescription.text = ""

                descriptions.forEach { description in
                    self.parisMeteoDescription.text! += description.key + ", "
                    
                    // TODO: Comprendre le tableau weather
                    self.getIcon(cityIcon: self.parisIcon, iconNumber: description.value)
                }
            }
        }
    }
    
    private func getIcon(cityIcon: UIImageView, iconNumber: String) {
        cityIcon.image = UIImage(named: iconNumber)
    }
    
    private func setupLabels() {
        parisTitle.layer.masksToBounds = true
        parisTitle.layer.cornerRadius = 10
        
        parisMeteoDescription.layer.masksToBounds = true
        parisMeteoDescription.layer.cornerRadius = 10
        
        newYorkTitle.layer.masksToBounds = true
        newYorkTitle.layer.cornerRadius = 10
        
        newYorkMeteoDescription.layer.masksToBounds = true
        newYorkMeteoDescription.layer.cornerRadius = 10
    }
}
