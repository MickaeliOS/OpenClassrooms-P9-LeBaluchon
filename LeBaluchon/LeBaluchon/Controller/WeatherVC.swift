//
//  WeatherVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 23/11/2022.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherService.shared.getWeather(lat: "48.856614", lon: "2.3522219") { success, tuple, error in
            if error != nil {
                //self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let (temperature, descriptions) = tuple, success == true else {
                return
            }
            
            self.testLabel.text = "Il fait \(temperature) degrés, "
            
            descriptions.forEach { description in
                self.testLabel.text! += description + ", "
            }

            self.testLabel.text! += "à Paris."
        }
    }
}
