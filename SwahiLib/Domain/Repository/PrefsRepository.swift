//
//  AppPrefences.swift
//  SwahiLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

class PrefsRepository {
    private enum Keys {
        static let isLoaded = "dataIsLoadedKey"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isDataLoaded: Bool {
        get {
            return userDefaults.bool(forKey: Keys.isLoaded)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.isLoaded)
        }
    }
}
