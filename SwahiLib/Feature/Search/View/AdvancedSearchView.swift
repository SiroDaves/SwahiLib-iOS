//
//  AdvancedSearchView.swift
//  SwahiLib
//
//  Created by @sirodevs on 15/11/2025.
//
//  Mirrors Android's AdvancedSearchScreen: search field + sort dropdown,
//  YOTE/MANENO/NAHAU/METHALI/MISEMO type filter chips, a result count
//  badge, and all matching sections stacked together (rather than a single
//  switched list with an alphabet sidebar, which is specific to Home).
//

import SwiftUI

struct AdvancedSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State private var searchText: String = ""
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isAtTop: Bool = true

    private let scrollSpace = "advancedSearchScroll"

    private var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                SearchBar(
                    text: $searchText,
                    onSearch: { query in viewModel.filterData(qry: query) }
                )
                SortDropdown(sortOrder: $viewModel.sortOrder)
            }
            .padding(.horizontal, 10)

            TypeFilterRow(selected: $viewModel.homeTab)
                .padding(.top, 10)

            ResultCountBadge(
                query: searchText,
                count: viewModel.totalResults(for: viewModel.homeTab)
            )
            .padding(.top, 4)

            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            Color.clear
                                .frame(height: 0)
                                .id("top")
                                .trackScrollOffset(coordinateSpace: scrollSpace) { offset in
                                    isAtTop = offset >= -5
                                }

                            if trimmedQuery.isEmpty {
                                EmptySearchPrompt()
                            } else {
                                resultSections
                            }

                            Color.clear.frame(height: 80)
                        }
                        .padding(.top, 8)
                    }
                    .coordinateSpace(name: scrollSpace)
                    .onAppear { scrollViewProxy = proxy }
                }

                if !isAtTop {
                    ScrollToTopButton {
                        withAnimation { scrollToTop() }
                    }
                    .padding()
                    .transition(.opacity)
                }
            }
        }
        .navigationTitle("Tafuta kwa Kina")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SearchModeMenu(searchMode: $viewModel.searchMode)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isAtTop)
    }

    @ViewBuilder
    private var resultSections: some View {
        let showWords = viewModel.homeTab == .all || viewModel.homeTab == .words
        let showIdioms = viewModel.homeTab == .all || viewModel.homeTab == .idioms
        let showProverbs = viewModel.homeTab == .all || viewModel.homeTab == .proverbs
        let showSayings = viewModel.homeTab == .all || viewModel.homeTab == .sayings

        if showWords {
            if !viewModel.filteredWords.isEmpty {
                WordsList(words: viewModel.filteredWords)
            } else {
                EmptySection(category: "maneno")
            }
        }

        if showIdioms {
            if !viewModel.filteredIdioms.isEmpty {
                IdiomsList(idioms: viewModel.filteredIdioms)
            } else {
                EmptySection(category: "nahau")
            }
        }

        if showProverbs {
            if !viewModel.filteredProverbs.isEmpty {
                ProverbsList(proverbs: viewModel.filteredProverbs)
            } else {
                EmptySection(category: "methali")
            }
        }

        if showSayings {
            if !viewModel.filteredSayings.isEmpty {
                SayingsList(sayings: viewModel.filteredSayings)
            } else {
                EmptySection(category: "misemo")
            }
        }
    }

    private func scrollToTop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy?.scrollTo("top", anchor: .top)
        }
    }
}
