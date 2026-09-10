//
//  WordRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/05/2025.
//  Updated to fetch from the Kamusi content API instead of Supabase.
//

import Foundation

protocol WordRepoProtocol {
    func fetchRemoteData() async throws
    func fetchLocalData() -> [Word]
    func getWordsByTitles(titles: [String]) -> [Word]
    func saveWord(_ word: Word)
    func updateWord(_ word: Word)
    func deleteLocalData()
}

class WordRepo: WordRepoProtocol {
    private let api: KamusiApiServiceProtocol
    private let wordData: WordDataManager

    init(api: KamusiApiServiceProtocol, wordData: WordDataManager) {
        self.api = api
        self.wordData = wordData
    }

    func fetchRemoteData() async throws {
        guard let wordDTOs: [WordDTO] = await api.fetchJson(.words) else {
            throw KamusiApiError.fetchFailed(.words)
        }

        let cdWords: [CDWord] = wordDTOs.map { dto in
            let cdWord = CDWord(context: self.wordData.bgContext)
            MapDtoToCd.mapToCd(dto, cdWord)
            return cdWord
        }

        print("✅ \(cdWords.count) words fetched")

        try await wordData.saveWords(cdWords)
        print("✅ Words saved successfully")
    }

    func fetchLocalData() -> [Word] {
        let words = wordData.fetchWords()
        return words.sorted { $0.rid < $1.rid }
    }

    func saveWord(_ word: Word) {
        wordData.saveWord(word)
    }

    func updateWord(_ word: Word) {
        wordData.updateWord(word)
    }

    func getWordsByTitles(titles: [String]) -> [Word] {
        let words = wordData.getWordsByTitles(titles: titles)
        return words.sorted { $0.rid < $1.rid }
    }

    func deleteLocalData() {
        wordData.deleteAllWords()
    }
}
