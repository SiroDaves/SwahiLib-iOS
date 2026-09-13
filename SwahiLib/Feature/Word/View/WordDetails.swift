//
//  WordDetails.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

import SwiftUI

struct WordDetails: View {
    @ObservedObject var viewModel: WordViewModel
    var title: String
    var meanings: [String]
    var synonyms: [Word]
    var conjugation: String
    var proverbs: [Proverb]
    var english: String?
    var onFeatureLocked: () -> Void
    
    private enum Constants {
        static let sizeXSmall: CGFloat = 2
        static let sizeSmall: CGFloat = 5
        static let sizeMedium: CGFloat = 10
        static let sizeLarge: CGFloat = 15
        static let fontSizeTitle: CGFloat = 20
        static let fontSizeBody: CGFloat = 16
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CollapsingHeader(title: title, subtitle: english)

                if !meanings.isEmpty {
                    Text("MAANA \(meanings.count)")
                        .bold()
                        .font(.system(size: Constants.fontSizeTitle))
                        .padding(.horizontal, Constants.sizeLarge)
                    MeaningsView(meanings: meanings)
                }

                if !conjugation.isEmpty {
                    Spacer().frame(height: 5)
                    Text("MNYAMBULIKO")
                        .bold()
                        .font(.system(size: Constants.fontSizeTitle))
                        .padding(.horizontal, Constants.sizeLarge)
                    Text(conjugation)
                        .italic()
                        .padding(.leading, Constants.sizeLarge)
                        .font(.system(size: Constants.fontSizeTitle))
                        .foregroundColor(Color(.primary1))
                }

                if !synonyms.isEmpty {
                    Spacer().frame(height: 5)

                    Text(synonyms.count == 1 ? L10n.synonym.uppercased() : "\(L10n.synonyms.uppercased()) \(synonyms.count)")
                        .bold()
                        .font(.system(size: Constants.fontSizeTitle))
                        .padding(.horizontal, Constants.sizeLarge)

                    WordSynonyms(
                        synonyms: synonyms,
                        onSynonymClicked: { synonym in
                            if viewModel.isProUser {
                                viewModel.loadWord(synonym)
                            } else {
                                onFeatureLocked()
                            }
                        }
                    )
                }
                
                if !proverbs.isEmpty {
                    Spacer().frame(height: 5)
                    Text("METHALI AMBATANISHI \(proverbs.count)")
                        .bold()
                        .font(.system(size: Constants.fontSizeTitle))
                        .padding(.horizontal, Constants.sizeLarge)
                    
                    ProverbsList(proverbs: proverbs)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct WordSynonyms: View {
    var synonyms: [Word]
    var onSynonymClicked: (Word) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(synonyms, id: \.id) { synonym in
                SynonymItem(
                    title: synonym.title,
                    onClick: {
                        onSynonymClicked(synonym)
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview{
    WordView(
        deepLinked: false, word: Word.sampleWords[0]
    )
}
