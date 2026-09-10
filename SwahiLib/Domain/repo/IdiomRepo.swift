//
//  IdiomRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//  Updated to fetch from the Kamusi content API instead of Supabase.
//

import Foundation

protocol IdiomRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Idiom]
    func getIdiomsByTitles(titles: [String]) -> [Idiom]
    func saveIdiom(_ idiom: Idiom)
    func updateIdiom(_ idiom: Idiom)
    func deleteLocalData()
}

class IdiomRepo: IdiomRepoProtocol {
    private let api: KamusiApiServiceProtocol
    private let idiomData: IdiomDataManager

    init(api: KamusiApiServiceProtocol, idiomData: IdiomDataManager) {
        self.api = api
        self.idiomData = idiomData
    }

    func fetchRemoteData() async throws {
        guard let idiomDTOs: [IdiomDTO] = await api.fetchJson(.idioms) else {
            throw KamusiApiError.fetchFailed(.idioms)
        }

        let cdIdioms: [CDIdiom] = idiomDTOs.map { dto in
            let cdIdiom = CDIdiom(context: self.idiomData.bgContext)
            MapDtoToCd.mapToCd(dto, cdIdiom)
            return cdIdiom
        }

        print("✅ \(cdIdioms.count) idioms fetched")
        try await idiomData.saveIdioms(cdIdioms)
    }

    func fetchLocalData() -> [Idiom] {
        let idioms = idiomData.fetchIdioms()
        return idioms.sorted { $0.rid < $1.rid }
    }

    func saveIdiom(_ idiom: Idiom) {
        idiomData.saveIdiom(idiom)
    }

    func updateIdiom(_ idiom: Idiom) {
        idiomData.updateIdiom(idiom)
    }

    func getIdiomsByTitles(titles: [String]) -> [Idiom] {
        let idioms = idiomData.getIdiomsByTitles(titles: titles)
        return idioms.sorted { $0.rid < $1.rid }
    }

    func deleteLocalData() {
        idiomData.deleteAllIdioms()
    }

}
