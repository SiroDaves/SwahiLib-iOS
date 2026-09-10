//
//  ContentSyncManager.swift
//  SwahiLib
//
//  Mirrors Android's SyncWorker: for each content endpoint, checks the
//  stored ETag against the server before re-downloading. Only endpoints
//  that actually changed get fetched and re-saved; the new ETag is only
//  persisted once the fetch+save succeeds, so a failed sync retries next
//  time instead of silently marking stale content as fresh.
//

import Foundation

protocol ContentSyncManagerProtocol {
    /// Syncs every content + library endpoint, skipping any that haven't
    /// changed since the last successful sync. Safe to call on every app
    /// launch.
    func syncAll() async
}

final class ContentSyncManager: ContentSyncManagerProtocol {
    private let api: KamusiApiServiceProtocol
    private let prefsRepo: PrefsRepo
    private let idiomRepo: IdiomRepoProtocol
    private let proverbRepo: ProverbRepoProtocol
    private let sayingRepo: SayingRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let libraryRepo: LibraryRepoProtocol

    init(
        api: KamusiApiServiceProtocol,
        prefsRepo: PrefsRepo,
        idiomRepo: IdiomRepoProtocol,
        proverbRepo: ProverbRepoProtocol,
        sayingRepo: SayingRepoProtocol,
        wordRepo: WordRepoProtocol,
        libraryRepo: LibraryRepoProtocol
    ) {
        self.api = api
        self.prefsRepo = prefsRepo
        self.idiomRepo = idiomRepo
        self.proverbRepo = proverbRepo
        self.sayingRepo = sayingRepo
        self.wordRepo = wordRepo
        self.libraryRepo = libraryRepo
    }

    func syncAll() async {
        await withTaskGroup(of: Void.self) { group in
            for endpoint in KamusiEndpoint.allCases {
                group.addTask { await self.syncEndpoint(endpoint) }
            }
        }
    }

    private func syncEndpoint(_ endpoint: KamusiEndpoint) async {
        let storedETag = prefsRepo.getETag(for: endpoint)
        guard let newETag = await api.fetchETag(endpoint, storedETag: storedETag) else {
            print("⏭ \(endpoint.path) — no changes")
            return
        }

        print("⬇ \(endpoint.path) changed — downloading")

        do {
            if endpoint.libraryCollectionKey != nil {
                try await libraryRepo.fetchRemoteData(endpoint)
            } else {
                switch endpoint {
                case .words: try await wordRepo.fetchRemoteData()
                case .idioms: try await idiomRepo.fetchRemoteData()
                case .proverbs: try await proverbRepo.fetchRemoteData()
                case .sayings: try await sayingRepo.fetchRemoteData()
                default:
                    print("⚠️ No sync handler registered for \(endpoint.path)")
                    return
                }
            }
            prefsRepo.setETag(newETag, for: endpoint)
            print("💾 \(endpoint.path) ETag saved: \(newETag)")
        } catch {
            print("⚠️ \(endpoint.path) sync failed — ETag not saved, will retry next launch: \(error.localizedDescription)")
        }
    }
}
