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
        setupLanguages()
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
    var languageConfiguration = LanguageConfiguration()
    let placeHolderTextToTranslate = "Text to translate"
    let placeHolderTranslatedText = "Translated text"
    let placeHolderColor = UIColor.lightGray
    
    // MARK: - Actions
    @IBAction func dismissKeyboard(_ sender: Any) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction func exchangeSourceAndDestination(_ sender: Any) {
        displayExchangedLanguages()
    }
    
    @IBAction func translate(_ sender: Any) {
        displayTraduction()
    }
    
    // MARK: - Private functions
    private func displayTraduction() {
        guard !textToTranslate.text.isEmpty else {
            self.presentAlert(with: "Please fill the text area.")
            return
        }
        
        let (source, destination) = languageConfiguration.getSourceAndDestinationLanguages()
        
        TraductionService.shared.getTraduction(source: source, target: destination, text: textToTranslate.text) { success, translatedText, error in
            if error != nil {
                self.presentAlert(with: "An error occurred")
                return
            }
            
            guard let translatedText = translatedText, success == true else {
                self.presentAlert(with: "An error occured, please try again.")
                return
            }
            
            self.translatedText.text = "\(translatedText)"
        }
    }
    
    private func displayExchangedLanguages() {
        languageConfiguration.exchangeLanguages()
        languageConfig()
        resetTextViews()
        textToTranslate.resignFirstResponder()
    }
    
    private func resetTextViews() {
        // When I want to switch languages, i'm reseting the textViews.
        textToTranslate.text = placeHolderTextToTranslate
        textToTranslate.textColor = placeHolderColor
        translatedText.text = placeHolderTranslatedText
        translatedText.textColor = placeHolderColor
    }
    
    private func languageConfig() {
        // Outlet's Configuration
        sourceLabel.text = languageConfiguration.sourceLanguage
        destinationLabel.text = languageConfiguration.destinationLanguage
        sourceFlag.image = UIImage(named: languageConfiguration.sourceFlag)
        destinationFlag.image = UIImage(named: languageConfiguration.destinationFlag)
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
    
    private func setupLanguages() {
        languageConfiguration.englishChangingLanguage()
        languageConfig()
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
