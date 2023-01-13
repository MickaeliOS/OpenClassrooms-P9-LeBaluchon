//
//  TraductionVC.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 09/11/2022.
//

import UIKit

class TraductionVC: UIViewController {
    
    // MARK: - Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        checkSystemLanguage()
    }

    // MARK: - Outlets
    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var destinationFlag: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var translateButton: UIButton!
    
    // MARK: - Variables
    let placeHolderTextToTranslate = "Text to translate"
    let placeHolderTranslatedText = "Translated text"
    let placeHolderColor = UIColor.lightGray
    
    // MARK: - Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func exchangeSourceAndDestination(_ sender: Any) {
        if sourceLabel.text == "French" {
            sourceFlag.image = UIImage(named: "united_states_of_america_round_icon_64")
            sourceLabel.text = "English"
            destinationFlag.image = UIImage(named: "france_round_icon_64")
            destinationLabel.text = "French"

        } else {
            sourceFlag.image = UIImage(named: "france_round_icon_64")
            sourceLabel.text = "French"
            destinationFlag.image = UIImage(named: "united_states_of_america_round_icon_64")
            destinationLabel.text = "English"
        }
        
        resetTextViews()
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func translate(_ sender: Any) {
        guard !textToTranslate.text.isEmpty else {
            self.presentAlert(with: "Please fill the text area.")
            return
        }
        
        let (source, destination) = getSourceAndDestinationLanguages()
        
        TraductionService.shared.getTraduction(source: source, target: destination, text: textToTranslate.text) { success, translatedText, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let translatedText = translatedText, success == true else {
                self.presentAlert(with: "An error occured, please try again.")
                return
            }
            
            self.translatedText.text = "\(translatedText)"
        }
    }
    
    // MARK: - Private functions
    private func resetTextViews() {
        // When I want to switch languages, i'm reseting the textViews.
        textToTranslate.text = placeHolderTextToTranslate
        textToTranslate.textColor = placeHolderColor
        translatedText.text = placeHolderTranslatedText
        translatedText.textColor = placeHolderColor
    }
    
    private func setupInterface() {
        // Source & Destination text view's place holder
        textToTranslate.text = "Text to translate"
        textToTranslate.textColor = .lightGray
        translatedText.text = "Translated text"
        translatedText.textColor = .lightGray
        
        // Translate button
        translateButton.layer.cornerRadius = 20
        
        // Exchange button
        exchangeButton.layer.cornerRadius = 20
    }
    
    private func getSourceAndDestinationLanguages() -> (String, String) {
        if sourceLabel.text == "French" {
            return ("fr", "en")
        } else {
            return ("en", "fr")
        }
    }
    
    private func checkSystemLanguage() {
        let preferredLanguages = NSLocale.preferredLanguages.first
        let firstLanguage = preferredLanguages?.components(separatedBy: "-").first
        
        guard let firstLanguage = firstLanguage else {
            return
        }
        
        if firstLanguage == "en" {
            exchangeSourceAndDestination(self)
        }
    }
}

// MARK: - Extentions
extension TraductionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderTextToTranslate
            textView.textColor = UIColor.lightGray
        }
    }
}
