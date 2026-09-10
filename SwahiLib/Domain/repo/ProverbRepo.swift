//
//  ProverbRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//  Updated to fetch from the Kamusi content API instead of Supabase.
//

import Foundation

protocol ProverbRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Proverb]
    func getProverbsByTitles(titles: [String]) -> [Proverb]
    func saveProverb(_ proverb: Proverb)
    func updateProverb(_ proverb: Proverb)
    func deleteLocalData()
}

class ProverbRepo: ProverbRepoProtocol {
    private let api: KamusiApiServiceProtocol
    private let proverbData: ProverbDataManager

    init(api: KamusiApiServiceProtocol, proverbData: ProverbDataManager) {
        self.api = api
        self.proverbData = proverbData
    }

    func fetchRemoteData() async throws {
        guard let proverbDTOs: [ProverbDTO] = await api.fetchJson(.proverbs) else {
            throw KamusiApiError.fetchFailed(.proverbs)
        }

        let cdProverbs: [CDProverb] = proverbDTOs.map { dto in
            let cdProverb = CDProverb(context: self.proverbData.bgContext)
            MapDtoToCd.mapToCd(dto, cdProverb)
            return cdProverb
        }

        print("✅ \(cdProverbs.count) proverbs fetched")
        try await proverbData.saveProverbs(cdProverbs)
    }

    func fetchLocalData() -> [Proverb] {
        let proverbs = proverbData.fetchProverbs()
        return proverbs.sorted { $0.rid < $1.rid }
    }

    func saveProverb(_ proverb: Proverb) {
        proverbData.saveProverb(proverb)
    }

    func updateProverb(_ proverb: Proverb) {
        proverbData.updateProverb(proverb)
    }

    func getProverbsByTitles(titles: [String]) -> [Proverb] {
        let proverbs = proverbData.getProverbsByTitles(titles: titles)
        return proverbs.sorted { $0.rid < $1.rid }
    }

    func deleteLocalData() {
        proverbData.deleteAllProverbs()
    }

}
