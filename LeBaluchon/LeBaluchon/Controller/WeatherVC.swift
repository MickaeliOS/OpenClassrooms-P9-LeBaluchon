//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import UIKit

class WeatherVC: UIViewController {
    
    // MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //getWeather()
        setupLabels()
        setupInterface()
    }

    // MARK: - Outlets
    @IBOutlet weak var refreshWeatherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Paris
    @IBOutlet weak var parisTitle: UILabel!
    @IBOutlet weak var parisIcon: UIImageView!
    @IBOutlet weak var parisTemp: UILabel!
    @IBOutlet weak var parisMeteoDescription: UILabel!
    
    // NewYork
    @IBOutlet weak var newYorkTitle: UILabel!
    @IBOutlet weak var newYorkIcon: UIImageView!
    @IBOutlet weak var newYorkTemp: UILabel!
    @IBOutlet weak var newYorkMeteoDescription: UILabel!
    
    // MARK: - Variables
    let weather = WeatherSupport()
    
    // MARK: - Actions
    @IBAction func refreshWeatherButton(_ sender: Any) {
        getWeather()
    }
    
    // MARK: - Private functions
    private func getWeather() {
        toggleActivityIndicator(shown: true)
        
        // New York
        WeatherService.shared.getWeather(city: "New York") { success, tuple, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                self.toggleActivityIndicator(shown: false)
                return
            }
            
            guard let (temperature, descriptions) = tuple, success == true else {
                self.presentAlert(with: "Can't fetch New York's weather data. Please press the refresh button.")
                self.toggleActivityIndicator(shown: false)
                return
            }
            
            let roundedTemperature = self.weather.roundedTemperature(temperature: temperature)
            self.newYorkTemp.text = "\(roundedTemperature) °C"
            self.newYorkMeteoDescription.text = ""
            
            descriptions.forEach { description in
                self.newYorkMeteoDescription.text! += description.key + ", "
                self.getIcon(cityIcon: self.newYorkIcon, iconNumber: description.value)
            }
            
            self.newYorkMeteoDescription.text = self.weather.removeComma(from: self.newYorkMeteoDescription.text)
            
            // Paris
            WeatherService.shared.getWeather(city: "Paris") { success, tuple, error in
                self.toggleActivityIndicator(shown: false)
                if error != nil {
                    self.presentAlert(with: error!.localizedDescription)
                    return
                }
                
                guard let (temperature, descriptions) = tuple, success == true else {
                    self.presentAlert(with: "Can't fetch Paris weather data. Please press the refresh button.")
                    return
                }
                
                let roundedTemperature = self.weather.roundedTemperature(temperature: temperature)
                self.parisTemp.text = "\(roundedTemperature) °C"
                self.parisMeteoDescription.text = ""

                descriptions.forEach { description in
                    self.parisMeteoDescription.text! += description.key + ", "
                    self.getIcon(cityIcon: self.parisIcon, iconNumber: description.value)
                }
                
                self.parisMeteoDescription.text = self.weather.removeComma(from: self.parisMeteoDescription.text)
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
    
    private func setupInterface() {
        refreshWeatherButton.layer.cornerRadius = 20
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        refreshWeatherButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}
