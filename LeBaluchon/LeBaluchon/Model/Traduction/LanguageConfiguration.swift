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
    var sourceFlag = "france_round_icon_64"
    var destinationFlag = "united_states_of_america_round_icon_64"
    var preferredLanguage = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first
    
    // MARK: - Functions
    func getSourceAndDestinationLanguages() -> (String, String) {
        if sourceLanguage == "French" {
            return ("fr", "en")
        }
        return ("en", "fr")
    }
    
    private func languageReversing(sourceLanguage: String, destinationLanguage: String) -> (String, String) {
        return (destinationLanguage, sourceLanguage)
    }
    
    private func updateLanguages(languages: (source: String, destination: String)) {
        sourceLanguage = languages.source
        destinationLanguage = languages.destination
    }
    
    private func flagReversing(sourceFlag: String, destinationFlag: String) -> (String, String) {
        return (destinationFlag, sourceFlag)
    }
    
    private func updateFlags(flags: (source: String, destination: String)) {
        sourceFlag = flags.source
        destinationFlag = flags.destination
    }
    
    func exchangeLanguages() {
        // Language changes
        let reversedLanguages = languageReversing(sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
        updateLanguages(languages: reversedLanguages)
        
        
        // Image changes
        let reversedFlags = flagReversing(sourceFlag: sourceFlag, destinationFlag: destinationFlag)
        updateFlags(flags: reversedFlags)
    }
    
    func englishChangingLanguage() {
        // If the user's language is not french, we put english configuration
        guard let preferredLanguage = preferredLanguage else { return }
        
        if preferredLanguage != "fr" {
            exchangeLanguages()
        }
    }
}
