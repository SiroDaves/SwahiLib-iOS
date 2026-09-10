//
//  WordView.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/08/2025.

import SwiftUI
import RevenueCat
import RevenueCatUI

struct WordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: WordViewModel = {
        DiContainer.shared.resolve(WordViewModel.self)
    }()
    
    let deepLinked: Bool
    let word: Word
    
    @State private var showToast = false
    @State private var showAlert = false
    @State private var showPaywall = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
            if showToast {
                let toastMessage = L10n.likedWord(for: word.title, isLiked: viewModel.isLiked)
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .alert(
            L10n.featureLocked,
            isPresented: $showAlert,
            actions: {
                Button(L10n.later, role: .cancel) {}
                Button(L10n.okay) { showPaywall = true }
            },
            message: {
                Text(
                    L10n.featureLockedDescXtra(
                        feature: L10n.featureViewWordSynonym
                    )
                )
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
        )
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
                PaywallView(displayCloseButton: true)
            #endif
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbarTitleDisplayMode(.inline)
        .task(
            {viewModel.loadWord(word)}
        )
        .onChange(of: viewModel.uiState) { newState in
            if case .liked = newState {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .scaleEffect(5)
                    .tint(.primary1)
            
            case .loaded:
                mainContent
            
            case .liked:
                mainContent
          
            case .error(let msg):
                ErrorState(message: msg) {
                    viewModel.loadWord(word)
                }
                
            default:
                EmptyView()
        }
    }
    
    private var mainContent: some View {
        WordDetails(
            viewModel: viewModel,
            title: viewModel.title,
            meanings: viewModel.meanings,
            synonyms: viewModel.synonyms,
            conjugation: viewModel.conjugation,
            proverbs: viewModel.proverbs,
            onFeatureLocked: { showAlert = true }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if (deepLinked) {
                        navigateToNewHomeView()
                    } else {
                        dismiss()
                    }
                } label: { Image(systemName: "chevron.backward") }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeWord(word: word)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }

                ShareLink(
                    item: viewModel.shareText(word: word),
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.primary1)
                }
            }
        }
        .navigationTitle(L10n.wordKiswa)
        .navigationBarBackButtonHidden(true)

    }
    
    private func navigateToNewHomeView() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let HomeView = HomeView()
                let hostingController = UIHostingController(rootView: HomeView)
                
                UIView.transition(with: window,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: {
                                    window.rootViewController = hostingController
                                })
            }
        }

}

#Preview{
    WordView(
        deepLinked: false, word: Word.sampleWords[0]
    )
}
