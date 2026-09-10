//
//  LibraryViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Mirrors Android's LibraryViewModel: the catalog itself is static, one
//  collection's items are loaded lazily the first time its screen is
//  opened (ensureLoaded), and the user can pull to refresh a single
//  collection explicitly (refresh).
//

import Foundation

final class LibraryViewModel: ObservableObject {
    let collections: [LibraryConfig] = LibraryCatalog.all

    @Published private(set) var itemsByCollection: [String: [LibraryDisplayItem]] = [:]
    @Published private(set) var isSyncing: Bool = false

    private let libraryRepo: LibraryRepoProtocol
    private let syncManager: ContentSyncManagerProtocol

    init(libraryRepo: LibraryRepoProtocol, syncManager: ContentSyncManagerProtocol) {
        self.libraryRepo = libraryRepo
        self.syncManager = syncManager
    }

    func config(for key: String) -> LibraryConfig? {
        LibraryCatalog.config(for: key)
    }

    func items(for key: String) -> [LibraryDisplayItem] {
        itemsByCollection[key] ?? []
    }

    /// Loads a collection from local storage if we already have it; only
    /// hits the network the first time a collection's screen is opened.
    @MainActor
    func ensureLoaded(_ key: String) async {
        if let cached = itemsByCollection[key], !cached.isEmpty { return }

        let local = libraryRepo.fetchLocalData(key)
        if !local.isEmpty {
            itemsByCollection[key] = local
            return
        }

        guard let endpoint = KamusiEndpoint.forLibraryKey(key) else { return }
        isSyncing = true
        do {
            try await libraryRepo.fetchRemoteData(endpoint)
        } catch {
            print("⚠️ Failed to load library collection \(key): \(error.localizedDescription)")
        }
        itemsByCollection[key] = libraryRepo.fetchLocalData(key)
        isSyncing = false
    }

    @MainActor
    func refresh(_ key: String) async {
        guard let endpoint = KamusiEndpoint.forLibraryKey(key) else { return }
        isSyncing = true
        do {
            try await libraryRepo.fetchRemoteData(endpoint)
        } catch {
            print("⚠️ Failed to refresh library collection \(key): \(error.localizedDescription)")
        }
        itemsByCollection[key] = libraryRepo.fetchLocalData(key)
        isSyncing = false
    }
}
