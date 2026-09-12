//
//  WordViewModel.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/08/2025.
//

import Foundation
import SwiftUI
import Combine

class WordViewModel: ObservableObject {
    @Published var isProUser: Bool = false
    
    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var conjugation: String = ""
    @Published var isLiked: Bool = false
    @Published var meanings: [String] = []
    @Published var synonyms: [Word] = []
    @Published var proverbs: [Proverb] = []
    @Published var english: String? = nil
    
    private let netUtils: NetworkUtils
    let prefsRepo: PrefsRepo
    private let proverbRepo: ProverbRepoProtocol
    private let wordRepo: WordRepoProtocol
    private let subsRepo: SubsRepoProtocol
    
    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PrefsRepo,
        proverbRepo: ProverbRepoProtocol,
        wordRepo: WordRepoProtocol,
        subsRepo: SubsRepoProtocol
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.proverbRepo = proverbRepo
        self.wordRepo = wordRepo
        self.subsRepo = subsRepo
    }
    
    private func verifySubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    self.isProUser = isActive
                    continuation.resume()
                }
            }
        }
    }
    
    func loadWord(_ word: Word) {
        uiState = .loading()
        isLiked = word.liked
        title = word.title
        conjugation = word.conjugation
        let trimmedEnglish = word.english.trimmingCharacters(in: .whitespacesAndNewlines)
        english = trimmedEnglish.isEmpty ? nil : trimmedEnglish
        
        loadRelatedProverbs(word: word)
        
        meanings = cleanText(
            word.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")
        
        let synonymTitles = (word.synonyms)
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        Task { @MainActor in
            if !synonymTitles.isEmpty {
                self.synonyms =  wordRepo.getWordsByTitles(titles: synonymTitles).sorted { ($0.title).lowercased() < ($1.title).lowercased() }
            } else {
                self.synonyms = []
            }
        }
        
        uiState = .loaded
    }
    
    func loadRelatedProverbs(word: Word){
        let allProverbs = proverbRepo.fetchLocalData()
        let searchTerm = word.title.lowercased()
        
        self.proverbs = allProverbs.filter { proverb in
            let proverbTitle = proverb.title.lowercased()
            let wordsInProverbs = proverbTitle.split(separator: " ").map { String($0) }
            
            return wordsInProverbs.contains { $0 == searchTerm }
        }
        .sorted { $0.title < $1.title }
    }

    func shareText(word: Word) -> String {
        let parts = cleanText(
            word.meaning.trimmingCharacters(in: .whitespacesAndNewlines)
        ).components(separatedBy: "|")
        
        let meaningsList: String
        if parts.count > 1 {
            meaningsList = parts.enumerated()
                .map { "\($0 + 1). \($1.trimmingCharacters(in: .whitespacesAndNewlines))" }
                .joined(separator: "\n")
        } else {
            meaningsList = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        
        var text = """
        \(word.title) ni \(L10n.wordKiswa)
        
        Maana:
        \(meaningsList)
        """
        
        if !word.conjugation.isEmpty {
            text += "\n\nMnyambuliko: \(word.conjugation)"
        }
        
        if !synonyms.isEmpty {
            let synonymList = synonyms.map { $0.title }.joined(separator: ", ")
            text += "\n\n\(synonyms.count == 1 ? "\(L10n.synonym): " : "\(L10n.synonyms) \(synonyms.count):\n")\(synonymList)"
        }
        
        text += "\n\n\(AppConstants.appTitle) - \(AppConstants.appTitle2)\n\(AppConstants.appLink)\n"
        
        return text
    }

    func likeWord(word: Word) {
        let updatedWord = Word(
            rid: word.rid,
            title: word.title,
            synonyms: word.synonyms,
            meaning: word.meaning,
            conjugation: word.conjugation,
            english: word.english,
            views: word.views,
            likes: word.likes,
            liked: !word.liked,
            createdAt: word.createdAt,
            updatedAt: word.updatedAt
        )
        
        wordRepo.updateWord(updatedWord)
        isLiked = updatedWord.liked
        uiState = .liked
    }
}
