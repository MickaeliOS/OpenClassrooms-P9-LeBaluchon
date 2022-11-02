//
//  AppDelegate.swift
//  LeBaluchon
//
//  Created by Mickaël Horn on 19/10/2022.
//

// Weather : <a href="https://www.flaticon.com/free-icons/weather" title="weather icons">Weather icons created by kosonicon - Flaticon</a>
// Translate : <a href="https://www.flaticon.com/fr/icones-gratuites/traduction" title="traduction icônes">Traduction icônes créées par Freepik - Flaticon</a>
// Exchange : <a href="https://www.flaticon.com/free-icons/convert" title="convert icons">Convert icons created by NewsIcons - Flaticon</a>
// US Flag : https://www.freeflagicons.com/country/united_states_of_america/round_icon/
// EU Flag : https://www.freeflagicons.com/country/european_union/round_icon/

// w3KstM52K0o1fGMtkNfRJn1cmB0Mbt5p

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

