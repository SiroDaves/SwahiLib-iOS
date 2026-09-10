//
//  HomeViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation
import WidgetKit
import StoreKit

final class HomeViewModel: ObservableObject {
    let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let subsRepo: SubsRepoProtocol
    private let notifyService: NotificationServiceProtocol
    private let syncManager: ContentSyncManagerProtocol
    
    @Published var allIdioms: [Idiom] = []
    @Published var likedIdioms: [Idiom] = []
    @Published var filteredIdioms: [Idiom] = []
    
    @Published var allProverbs: [Proverb] = []
    @Published var likedProverbs: [Proverb] = []
    @Published var filteredProverbs: [Proverb] = []
    
    @Published var allSayings: [Saying] = []
    @Published var likedSayings: [Saying] = []
    @Published var filteredSayings: [Saying] = []
    
    @Published var allWords: [Word] = []
    @Published var likedWords: [Word] = []
    @Published var filteredWords: [Word] = []
    
    @Published var uiState: UiState = .idle
    @Published var homeTab: HomeTab = .words
    @Published var isProUser: Bool = false
    @Published var notificationsEnabled: Bool = false
    @Published var notificationTime: Date
    
    init(
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol,
        subsRepo: SubsRepoProtocol,
        notifyService: NotificationServiceProtocol,
        syncManager: ContentSyncManagerProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
        self.notifyService = notifyService
        self.syncManager = syncManager
        
        let savedHour = prefsRepo.notificationHour
        let savedMinute = prefsRepo.notificationMinute
        
        var components = DateComponents()
        components.hour = savedHour
        components.minute = savedMinute
        self.notificationTime = Calendar.current.date(from: components) ?? Date()
        self.notificationsEnabled = prefsRepo.notificationsEnabled
        
        if notificationsEnabled {
            notifyService.checkNotificationPermission()
        }
    }
    
    private func validateSubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    self.isProUser = isActive
                    continuation.resume()
                }
            }
        }
    }
    
    func fetchData() {
        print("Fetching data")
        self.uiState = .loading("Inapakia data ...")

        Task { @MainActor in
            try await validateSubscription(isOnline: false)
            self.allIdioms = idiomRepo.fetchLocalData()
            self.allProverbs = proverbRepo.fetchLocalData()
            self.allSayings = sayingRepo.fetchLocalData()
            self.allWords = wordRepo.fetchLocalData()
            
            checkForDuplicateIDs()
            self.filterData(qry: "")
            self.uiState = .filtered

            refreshContentInBackground()
        }
    }

    private func refreshContentInBackground() {
        Task { @MainActor in
            let before = (allIdioms.count, allProverbs.count, allSayings.count, allWords.count)

            await syncManager.syncAll()

            self.allIdioms = idiomRepo.fetchLocalData()
            self.allProverbs = proverbRepo.fetchLocalData()
            self.allSayings = sayingRepo.fetchLocalData()
            self.allWords = wordRepo.fetchLocalData()

            let after = (allIdioms.count, allProverbs.count, allSayings.count, allWords.count)
            if before != after {
                self.filterData(qry: "")
            }
        }
    }
    
    private func checkForDuplicateIDs() {
        let idiomIDs = allIdioms.map { $0.rid }
        let duplicateIdiomIDs = Dictionary(grouping: idiomIDs, by: { $0 })
            .filter { $0.value.count > 1 }
            .keys
        
        if !duplicateIdiomIDs.isEmpty {
            print("⚠️ Found duplicate idiom IDs: \(duplicateIdiomIDs)")
        }
    }
    
    func filterData(qry: String) {
        let trimmedQuery = qry.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        self.uiState = .filtering
        
        switch self.homeTab {
        case .idioms:
            self.likedIdioms = allIdioms.filter { $0.liked }
            self.filteredIdioms = trimmedQuery.isEmpty
                ? allIdioms
                : allIdioms.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            
        case .sayings:
            self.likedSayings = allSayings.filter { $0.liked }
            self.filteredSayings = trimmedQuery.isEmpty
                ? allSayings
                : allSayings.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            
        case .proverbs:
            self.likedProverbs = allProverbs.filter { $0.liked }
            self.filteredProverbs = trimmedQuery.isEmpty
                ? allProverbs
                : allProverbs.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
            
        case .words:
            self.likedWords = allWords.filter { $0.liked }
            self.filteredWords = trimmedQuery.isEmpty
                ? allWords
                : allWords.filter { $0.title.lowercased().hasPrefix(trimmedQuery) }
        }
        
        self.uiState = .filtered
    }

    func updateParentalGate(value: Bool) {
        prefsRepo.shownParentalGate = value
    }
    
    @MainActor func promptReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            AppStore.requestReview(in: scene)
        }
    }
    
    func toggleNotifications(_ enabled: Bool) {
        notificationsEnabled = enabled
        prefsRepo.notificationsEnabled = enabled
        
        if enabled {
            notifyService.checkNotificationPermission()
            scheduleNotifications()
        } else {
            notifyService.cancelDailyNotifications()
        }
    }
    
    func updateNotificationTime(_ time: Date) {
        notificationTime = time
        prefsRepo.setNotificationTime(hour: time.hour, minute: time.minute)
        
        if notificationsEnabled {
            scheduleNotifications()
        }
    }
    
    private func scheduleNotifications() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        notifyService.scheduleDailyWordNotification(
            at: components.hour ?? 6,
            minute: components.minute ?? 0
        )
    }

    func clearAllData() {
        print("Clearing data")
        self.uiState = .loading("Inafuta data ...")

        Task { @MainActor in
            self.idiomRepo.deleteLocalData()
            self.proverbRepo.deleteLocalData()
            self.sayingRepo.deleteLocalData()
            self.wordRepo.deleteLocalData()
            
            prefsRepo.resetPrefs()
            self.uiState = .loaded
        }
    }
}

extension Date {
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
}
