//
//  HomeLikes.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeLikes: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var showPaywall: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 1) {
                    CustomTabTitles(
                        selectedTab: viewModel.homeTab,
                        onSelect: { homeTab in
                            viewModel.homeTab = homeTab
                        }
                    )
                    .padding(.leading, 10)

                    switch viewModel.homeTab {
                        case .idioms:
                            IdiomsList(idioms: viewModel.likedIdioms)
                        case .proverbs:
                            ProverbsList(proverbs: viewModel.likedProverbs)
                        case .sayings:
                            SayingsList(sayings: viewModel.likedSayings)
                        case .words:
                            WordsList(words: viewModel.likedWords)
                    }
                }
            }
            if !viewModel.isProUser {
                UpgradeBanner1 { showPaywall = true }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .padding(.vertical)
        .navigationTitle("Vipendwa")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.regularMaterial, for: .navigationBar)
    }
}
