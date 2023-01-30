//
//  ExchangeVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 20/10/2022.
//

import UIKit

class ExchangeVC: UIViewController {
    // MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        //displayLatestChangeRates()
    }

    // MARK: - Outlets
    @IBOutlet weak var sourceAmount: UITextField!
    @IBOutlet weak var destinationAmount: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var eurToUsdLabel: UILabel!
    @IBOutlet weak var usdToEurLabel: UILabel!
    @IBOutlet weak var refreshRateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    let exchange = ExchangeControl()
    
    // MARK: - Actions
    @IBAction func convert(_ sender: Any) {
        displayConversionResult()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        sourceAmount.resignFirstResponder()
    }
    
    @IBAction func refreshRate(_ sender: Any) {
        refreshingProcess()
    }
    
    // MARK: - Private functions
    private func displayConversionResult() {
        do {
            let result = try exchange.amountControl(amount: sourceAmount.text)
            calculateExchangeRate(amount: result)
        } catch let error as ExchangeControl.AmountError {
            presentAlert(with: error.localizedDescription)
        } catch {
            presentAlert(with: "An error occured")
        }
    }

    private func calculateExchangeRate(amount: Double) {
        do {
            let result = try exchange.convertCurrency(amount: amount)
            self.destinationAmount.text = result
            
        } catch let error as ExchangeControl.CurrencyError {
            switch error {
                case .unknownRate:
                presentAlert(with: error.localizedDescription)
            }
        } catch {
            presentAlert(with: "An error occured")
        }
    }

    
    private func displayLatestChangeRates() {
        // I'm hidding the refresh button to prevent the user for multiple input
        toggleActivityIndicator(shown: true)

        // EUR to USD
        ExchangeService.shared.getLatestChangeRate(from: "EUR", to: "USD") { success, result, error in
            if error != nil {
                self.presentAlert(with: "An error occurred")
                
                // If the first call fails, it means it will never execute the second one and I need to
                // hide the ActivityIndicator and put the button back
                self.toggleActivityIndicator(shown: false)
                return
            }
            
            guard let result = result, success == true else {
                self.presentAlert(with: "Can't fetch the EUR to USD rate. Please press the refresh button.")
                
                // Same logic as above, I need to hide the AI and and display the button
                self.toggleActivityIndicator(shown: false)
                return
            }
            
            self.eurToUsdLabel.text = "1 EUR = \(result) USD"
            
            // USD to EUR
            ExchangeService.shared.getLatestChangeRate(from: "USD", to: "EUR") { success, result, error in
                // Here, both of the API calls finished, so I have to make the button reappear and
                // hide the ActivityIndicator
                self.toggleActivityIndicator(shown: false)

                if error != nil {
                    self.presentAlert(with: "An error occurred")
                    return
                }
                
                guard let result = result, success == true else {
                    self.presentAlert(with: "Can't fetch the USD to EUR rate. You can either press the refresh button or convert your value.")
                    return
                }
                
                self.usdToEurLabel.text = "1 USD = \(result) EUR"
            }
        }
    }
    
    private func refreshingProcess() {
        displayLatestChangeRates()
        resetTextViews()
    }
    
    private func setupInterface() {
        convertButton.layer.cornerRadius = 20
        refreshRateButton.layer.cornerRadius = 15
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        // If shown is true, then the refresh button is hidden and we display the Activity Indicator
        // If not, we hide the Activity Indicator and show the refresh button
        refreshRateButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func resetTextViews() {
        sourceAmount.text = ""
        destinationAmount.text = ""
    }
}

// MARK: - Extentions
extension ExchangeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sourceAmount.resignFirstResponder()
        return true
    }
}
