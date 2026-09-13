//
//  LibraryRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Mirrors Android's LibraryRepo: fetches a collection's raw JSON, parses
//  it with LibraryMapper, and replaces whatever was stored locally for
//  that collection.
//

import Foundation

protocol LibraryRepoProtocol {
    /// Fetches and stores one maktaba collection. Throws if the endpoint
    /// isn't a library endpoint or the fetch/parse fails.
    func fetchRemoteData(_ endpoint: KamusiEndpoint) async throws
    func fetchLocalData(_ collectionKey: String) -> [LibraryDisplayItem]
    func hasLocalData(_ collectionKey: String) -> Bool
    func deleteLocalData()
}

class LibraryRepo: LibraryRepoProtocol {
    private let api: KamusiApiServiceProtocol
    private let libraryData: LibraryDataManager

    init(api: KamusiApiServiceProtocol, libraryData: LibraryDataManager) {
        self.api = api
        self.libraryData = libraryData
    }

    func fetchRemoteData(_ endpoint: KamusiEndpoint) async throws {
        guard let collectionKey = endpoint.libraryCollectionKey else {
            throw KamusiApiError.fetchFailed(endpoint)
        }
        guard let raw = await api.fetchRawJson(endpoint) else {
            throw KamusiApiError.fetchFailed(endpoint)
        }

        let items = LibraryMapper.map(collectionKey: collectionKey, rawJson: raw)
        print("✅ \(items.count) \(collectionKey) items fetched")
        try await libraryData.replaceAll(items, forCollection: collectionKey)
    }

    func fetchLocalData(_ collectionKey: String) -> [LibraryDisplayItem] {
        libraryData.fetchAll(forCollection: collectionKey)
    }

    func hasLocalData(_ collectionKey: String) -> Bool {
        libraryData.count(forCollection: collectionKey) > 0
    }

    func deleteLocalData() {
        libraryData.deleteAll()
    }
}
