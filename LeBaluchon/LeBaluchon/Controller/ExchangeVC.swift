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
    }
    
    // Outlets
    @IBOutlet weak var moneyFromButton: UIButton!
    @IBOutlet weak var MoneyFromText: UITextField!
    @IBOutlet weak var moneyToButton: UIButton!
    @IBOutlet weak var moneyToText: UITextField!
    
    // Actions
    @IBAction func formControl(_ sender: Any) {
        /*let from = moneyFromButton.titleLabel!.text!
        let to = moneyToButton.titleLabel!.text!*/
        let amount = MoneyFromText.text

        guard let amount = amount else {
            presentAlert(with: "Please fill a currency you want to convert.")
            return
        }
        
        calculateExchangeRate(from: "EUR", to: "USD", amount: amount)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        MoneyFromText.resignFirstResponder()
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
    
    private func setupCurrencySymbols() {
        // To Do :
        // Appel de l'API pour obtenir la liste des symboles tels que : EUR, USD, etc.
        // Ensuite, afficher par défaut en titre des boutons, EUR pour from, et USD pour to.
    }
}
