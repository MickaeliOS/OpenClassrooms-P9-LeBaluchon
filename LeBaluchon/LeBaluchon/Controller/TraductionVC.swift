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
    }

    // MARK: - Outlets
    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var destinationFlag: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    
    // MARK: - Variables
    let placeHolderSourceText = "Text to translate"
    let placeHolderTranslatedText = "Translated text"
    let placeHolderColor = UIColor.lightGray
    
    // MARK: - Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        sourceTextView.resignFirstResponder()
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
    }
    
    @IBAction func translateButton(_ sender: Any) {
        guard !sourceTextView.text.isEmpty else {
            self.presentAlert(with: "Please fill the text area.")
            return
        }
        
        let (source, destination) = sourceAndDestinationCheck()
        
        TraductionService.shared.getTraduction(source: source, target: destination, text: sourceTextView.text) { success, translatedText, error in
            if error != nil {
                self.presentAlert(with: error!.localizedDescription)
                return
            }
            
            guard let translatedText = translatedText, success == true else {
                self.presentAlert(with: "An error occured, please try again.")
                return
            }
            
            self.translatedTextView.text = "\(translatedText)"
        }
    }
    
    // MARK: - Private functions
    private func resetTextViews() {
        // When I want to switch languages, i'm reseting the textViews.
        sourceTextView.text = placeHolderSourceText
        sourceTextView.textColor = placeHolderColor
        translatedTextView.text = placeHolderTranslatedText
        translatedTextView.textColor = placeHolderColor
    }
    
    private func setupInterface() {
        // Source & Destination text view's place holder
        sourceTextView.text = "Text to translate"
        sourceTextView.textColor = .lightGray
        translatedTextView.text = "Translated text"
        translatedTextView.textColor = .lightGray
        
        // Translate button
        translateButton.layer.cornerRadius = 20
    }
    
    private func sourceAndDestinationCheck() -> (String, String) {
        if sourceLabel.text == "French" {
            return ("fr", "en")
        } else {
            return ("en", "fr")
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
            textView.text = placeHolderSourceText
            textView.textColor = UIColor.lightGray
        }
    }
}
