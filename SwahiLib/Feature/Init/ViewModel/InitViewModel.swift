//
//  Step1ViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//  Updated to delegate content sync to ContentSyncManager (ETag-aware)
//  instead of calling each repo's fetchRemoteData() directly.
//

import Foundation

final class InitViewModel: ObservableObject {
    @Published var uiState: UiState = .idle

    private let prefsRepo: PrefsRepo
    private let syncManager: ContentSyncManagerProtocol

    init(
        prefsRepo: PrefsRepo,
        syncManager: ContentSyncManagerProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.syncManager = syncManager
    }

    func initializeData() {
        Task {
            await fetchAndSaveData()
        }
    }

    func fetchAndSaveData() async {
        await MainActor.run {
            self.uiState = .loading("Inapakia data ...")
        }

        await syncManager.syncAll()
        prefsRepo.isDataLoaded = true

        await MainActor.run {
            self.uiState = .saved
        }

        print("✅ Data fetched and saved successfully.")
    }
}
