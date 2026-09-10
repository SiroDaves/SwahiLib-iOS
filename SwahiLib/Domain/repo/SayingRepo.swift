//
//  SayingRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//  Updated to fetch from the Kamusi content API instead of Supabase.
//

import Foundation

protocol SayingRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Saying]
    func getSayingsByTitles(titles: [String]) -> [Saying]
    func saveSaying(_ saying: Saying)
    func updateSaying(_ saying: Saying)
    func deleteLocalData()
}

class SayingRepo: SayingRepoProtocol {
    private let api: KamusiApiServiceProtocol
    private let sayingData: SayingDataManager

    init(api: KamusiApiServiceProtocol, sayingData: SayingDataManager) {
        self.api = api
        self.sayingData = sayingData
    }

    func fetchRemoteData() async throws {
        guard let sayingDTOs: [SayingDTO] = await api.fetchJson(.sayings) else {
            throw KamusiApiError.fetchFailed(.sayings)
        }

        let cdSayings: [CDSaying] = sayingDTOs.map { dto in
            let cdSaying = CDSaying(context: self.sayingData.bgContext)
            MapDtoToCd.mapToCd(dto, cdSaying)
            return cdSaying
        }

        print("✅ \(cdSayings.count) sayings fetched")
        try await sayingData.saveSayings(cdSayings)
    }

    func fetchLocalData() -> [Saying] {
        let sayings = sayingData.fetchSayings()
        return sayings.sorted { $0.rid < $1.rid }
    }

    func saveSaying(_ saying: Saying) {
        sayingData.saveSaying(saying)
    }

    func updateSaying(_ saying: Saying) {
        sayingData.updateSaying(saying)
    }

    func getSayingsByTitles(titles: [String]) -> [Saying] {
        let sayings = sayingData.getSayingsByTitles(titles: titles)
        return sayings.sorted { $0.rid < $1.rid }
    }

    func deleteLocalData() {
        sayingData.deleteAllSayings()
    }

}
