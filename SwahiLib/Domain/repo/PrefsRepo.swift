//
//  PrefsRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

class PrefsRepo {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isUserAKid: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isUserAKid) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isUserAKid) }
    }
    
    var shownParentalGate: Bool {
        get { userDefaults.bool(forKey: PrefConstants.shownParentalGate) }
        set { userDefaults.set(newValue, forKey: PrefConstants.shownParentalGate) }
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isLoaded) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isLoaded) }
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: PrefConstants.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: PrefConstants.installDate) }
    }
    
    var lastAppOpenTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.lastAppOpenTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastAppOpenTime) }
    }
    
    var notificationHour: Int {
        get { userDefaults.integer(forKey: PrefConstants.notificationHour) }
        set { userDefaults.set(newValue, forKey: PrefConstants.notificationHour) }
    }
    
    var notificationMinute: Int {
        get { userDefaults.integer(forKey: PrefConstants.notificationMinute) }
        set { userDefaults.set(newValue, forKey: PrefConstants.notificationMinute) }
    }
    
    var notificationsEnabled: Bool {
        get { userDefaults.bool(forKey: PrefConstants.notificationsEnabled) }
        set { userDefaults.set(newValue, forKey: PrefConstants.notificationsEnabled) }
    }
    
    func approveShowingPrompt(hours: Int) -> Bool {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return true }
        
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - lastTime
        let hoursInSeconds = TimeInterval(hours * 60 * 60)
        
        return timeDifference >= hoursInSeconds
    }
    
    func setNotificationTime(hour: Int, minute: Int) {
        notificationHour = hour
        notificationMinute = minute
    }
    
    func updateAppOpenTime() {
        lastAppOpenTime = Date().timeIntervalSince1970
    }
    
    func getTimeSinceLastOpen() -> TimeInterval {
        let lastTime = lastAppOpenTime
        if lastTime == 0 { return 0 }
        return Date().timeIntervalSince1970 - lastTime
    }
    
    func getETag(for endpoint: KamusiEndpoint) -> String? {
        userDefaults.string(forKey: AppConstants.etagKeyPrefix + endpoint.prefKey)
    }

    func setETag(_ etag: String, for endpoint: KamusiEndpoint) {
        userDefaults.set(etag, forKey: AppConstants.etagKeyPrefix + endpoint.prefKey)
    }

    func resetPrefs() {
        installDate = Date()
        isUserAKid = false
        isDataLoaded = false
        KamusiEndpoint.allCases.forEach {
            userDefaults.removeObject(forKey: AppConstants.etagKeyPrefix + $0.prefKey)
        }
    }
}
