//
//  Traduction.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 16/01/2023.
//

import Foundation
import UIKit

class LanguageConfiguration {
    // MARK: - Variables
    var sourceLanguage = "French"
    var destinationLanguage = "English"
    var sourceImage = UIImage(named: "france_round_icon_64")
    var destinationImage = UIImage(named: "united_states_of_america_round_icon_64")
    var preferredLanguage = NSLocale.preferredLanguages.first
    
    // MARK: - Functions
    func checkSystemLanguage() {
        let preferredLanguages = preferredLanguage
        let firstLanguage = preferredLanguages?.components(separatedBy: "-").first
        
        guard let firstLanguage = firstLanguage else {
            return
        }
        
        if firstLanguage == "en" {
            exchangeLanguages()
        }
    }
    
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
        let tempImage = sourceImage
        sourceImage = destinationImage
        destinationImage = tempImage
    }
}
