//
//  ExchangeVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 20/10/2022.
//

import UIKit

class ExchangeVC: UIViewController {
    // Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupCurrencySymbols()
        setupInterface()
        getLatestChangeRates()
    }
    
    // Outlets
    @IBOutlet weak var moneyFromButton: UIButton!
    @IBOutlet weak var moneyFromText: UITextField!
    @IBOutlet weak var moneyToButton: UIButton!
    @IBOutlet weak var moneyToText: UITextField!
    @IBOutlet weak var exchangeRateDataLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var eurToUsdLabel: UILabel!
    @IBOutlet weak var usdToEurLabel: UILabel!
    
    // Actions
    @IBAction func formControl(_ sender: Any) {
        /*let from = moneyFromButton.titleLabel!.text!
        let to = moneyToButton.titleLabel!.text!*/
        let amount = moneyFromText.text

        guard let amount = amount else {
            presentAlert(with: "Please fill a currency you want to convert.")
            return
        }
        
        calculateExchangeRate(from: "EUR", to: "USD", amount: amount)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        moneyFromText.resignFirstResponder()
    }
    
    // Private functions
    private func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func calculateExchangeRate(from: String, to: String, amount: String) {
        ExchangeService.shared.getExchangeRate(from: from, to: to, amount: amount) { success, result, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let result = result, success == true else {
                return
            }
            
            self.moneyToText.text = "\(result)"
        }
    }
    
    private func getLatestChangeRates() {
        
        // EUR to USD
        ExchangeService.shared.getLatestChangeRate(from: "EUR", to: "USD") { success, result, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let result = result, success == true else {
                return
            }
            
            self.eurToUsdLabel.text = "\(result)"
        }
        
        // USD to EUR
        ExchangeService.shared.getLatestChangeRate(from: "USD", to: "EUR") { success, result, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let result = result, success == true else {
                return
            }
            
            self.usdToEurLabel.text = "\(result)"
        }
    }
    
    /* private func setupCurrencySymbols() {
        ExchangeService.shared.getSymbols { success, result, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let result = result, success == true else {
                return
            }
            
            self.moneyToText.text = "\(result)"
            // Success est à false, regarde si c'est bon niveau appel
        }
    } */
    
    private func setupInterface() {
        calculateButton.layer.cornerRadius = 20
    }
}

extension ExchangeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moneyFromText.resignFirstResponder()
        return true
    }
}
