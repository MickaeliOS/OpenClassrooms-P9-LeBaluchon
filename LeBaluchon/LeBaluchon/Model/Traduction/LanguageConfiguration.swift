//
//  Traduction.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 16/01/2023.
//

import Foundation

class LanguageConfiguration {
    // MARK: - Variables
    var sourceLanguage = "French"
    var destinationLanguage = "English"
    var sourceImageName = "france_round_icon_64"
    var destinationImageName = "united_states_of_america_round_icon_64"
    var preferredLanguage = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first
    
    // MARK: - Functions
    func getSourceAndDestinationLanguages() -> (String, String) {
        if sourceLanguage == "French" {
            return ("fr", "en")
        } else {
            return ("en", "fr")
        }
    }
    
    func exchangeLanguages() {
        // Language changes
        let tempLanguage = sourceLanguage
        sourceLanguage = destinationLanguage
        destinationLanguage = tempLanguage
        
        // Image changes
        let tempImage = sourceImageName
        sourceImageName = destinationImageName
        destinationImageName = tempImage
    }
    
    func englishChangingLanguage() {
        guard let preferredLanguage = preferredLanguage else { return }
        
        if preferredLanguage == "en" {
            exchangeLanguages()
        }
    }
}
