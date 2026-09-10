//
//  InitView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI

struct InitView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel: InitViewModel = {
        DiContainer.shared.resolve(InitViewModel.self)
    }()
    
    @State private var navigateToNextScreen = false
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                HomeView()
            } else {
                mainContent
            }
        }
        .onAppear {
            startInitialization()
        }
    }

    private var mainContent: some View {
        VStack {
            stateContent
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading(_):
            LoadingState(
                fileName: "opener-loading"
            )

        case .error(let msg):
            ErrorState(message: msg) {
                viewModel.initializeData()
            }
            .onAppear {
                navigateToNextScreen = true
            }

        case .saved:
            EmptyState()
                .onAppear {
                    navigateToNextScreen = true
                }

        default:
            EmptyState()
        }
    }

    private func startInitialization() {
        let prefsRepo = DiContainer.shared.resolve(PrefsRepo.self)
        
        if prefsRepo.isDataLoaded {
            navigateToNextScreen = true
        } else {
            viewModel.initializeData()
        }
    }
}
