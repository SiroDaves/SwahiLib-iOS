//
//  HomeSearch.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeSearch: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText: String = ""
    @State private var selectedLetter: String? = nil
    @State private var isSearching: Bool = true
    @State private var showPaywall: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isAtTop: Bool = true

    private let scrollSpace = "homeSearchScroll"

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Color.clear
                                .frame(height: 0)
                                .id("top")
                                .trackScrollOffset(coordinateSpace: scrollSpace) { offset in
                                    isAtTop = offset >= -5
                                }

                            SearchBar(
                                text: $searchText,
                                onSearch: { query in
                                    viewModel.filterData(qry: query)
                                }
                            )
                            .padding(.horizontal, 10)
                            
                            CustomTabTitles(
                                selectedTab: viewModel.homeTab,
                                onSelect: { homeTab in
                                    viewModel.homeTab = homeTab
                                    viewModel.filterData(qry: "")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        scrollToTop()
                                    }
                                }
                            )
                            .padding(.leading, 10)

                            HomeSearchView(
                                viewModel: viewModel,
                                selectedLetter: $selectedLetter
                            )
                        }
                        .onAppear {
                            self.scrollViewProxy = proxy
                        }
                        .onChange(of: viewModel.homeTab) { _ in
                            if scrollViewProxy == nil {
                                self.scrollViewProxy = proxy
                            }
                        }
                    }
                    .coordinateSpace(name: scrollSpace)
                }

                VStack(alignment: .trailing, spacing: 10) {
                    if !isAtTop {
                        ScrollToTopButton {
                            withAnimation {
                                scrollToTop()
                            }
                        }
                        .transition(.opacity)
                    }

                    AdvancedSearchFAB(expanded: isAtTop)
                }
                .animation(.easeInOut(duration: 0.2), value: isAtTop)
                .padding()

                if !viewModel.isProUser {
                    UpgradeBanner1 { showPaywall = true }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(displayCloseButton: true)
            }
            .navigationTitle("SwahiLib")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        HomeLikes(viewModel: viewModel)
                    } label: {
                        Image(systemName: "heart.fill")
                    }
                }
            }
        }
    }
    
    private func scrollToTop() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy?.scrollTo("top", anchor: .top)
        }
    }
}

struct HomeSearchView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedLetter: String?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if viewModel.isProUser {
                VerticalLetters(
                    selectedLetter: selectedLetter,
                    onLetterSelected: { letter in
                        selectedLetter = letter
                        viewModel.filterData(qry: letter)
                    }
                )
                .frame(width: 60)
            }

            switch viewModel.homeTab {
                case .idioms:
                    IdiomsList(idioms: viewModel.filteredIdioms)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                case .proverbs:
                    ProverbsList(proverbs: viewModel.filteredProverbs)
                        .frame(maxWidth: .infinity, alignment: .leading)
                case .sayings:
                    SayingsList(sayings: viewModel.filteredSayings)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                case .words:
                    WordsList(words: viewModel.filteredWords)
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    HStack(alignment: .top, spacing: 10) {
        VerticalLetters(
            selectedLetter: "A",
            onLetterSelected: { letter in
                //
            }
        )
        .frame(width: 60)
        WordsList(
            words: Word.sampleWords
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
