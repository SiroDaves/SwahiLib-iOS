//
//  AppConstants.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

struct AppConstants {
    static let appTitle = "SwahiLib"
    static let appTitle2 = "Kamusi ya Kiswahili"
    static let appTagline = "Kiswahili Kitukuzwe"
    static let appCredits = "© Siro Devs"
    static let entitlements = "swahilib_offering_1"
    static let appLink = "https://linktr.ee/SwahilibApp"
    static let supportEmail = "futuristicken@gmail.com"
    
    static let wordsRefreshTask = "com.swahilib.wordstask.refresh"
    static let wordsProcessingTask = "com.swahilib.wordstask.processing"

    static let kamusiApiBaseURL = "https://swahilive.vercel.app/"
    
    static let etagKeyPrefix = "etagKey_"
}

struct PrefConstants {
    static let isLoaded = "dataIsLoadedKey"
    static let installDate = "installDateKey"
    static let isUserAKid = "isUserAKidKey"
    static let shownParentalGate = "shownParentalGateKey"
    static let usageTime = "usageTimeKey"
    static let isProUser = "isProUserKey"
    static let selectAfresh = "selectAfreshKey"
    static let lastAppOpenTime = "lastAppOpenTimeKey"
    static let notificationsEnabled = "notificationsEnabledKey"
    static let notificationHour = "notificationHourKey"
    static let notificationMinute = "notificationMinuteKey"
}

struct AppSecrets {
    static let rc_api_key: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["REVENUECAT_API_KEY"] as? String else {
            fatalError("Missing REVENUECAT_API_KEY in Secrets.plist")
        }
        return value
    }()

    static let sb_url: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["SUPABASE_URL"] as? String else {
            fatalError("Missing SUPABASE_URL in Secrets.plist")
        }
        return value
    }()

    static let sb_anon_key: String = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict["SUPABASE_ANON_KEY"] as? String else {
            fatalError("Missing SUPABASE_ANON_KEY in Secrets.plist")
        }
        return value
    }()
}
