//
//  HomeView.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    @StateObject private var libraryViewModel: LibraryViewModel = {
        DiContainer.shared.resolve(LibraryViewModel.self)
    }()
    
    private enum ActiveSheet: Identifiable {
        case parentalGate
        case paywall
        
        var id: Int { hashValue }
    }
    
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onAppear {
            #if !DEBUG
            if !viewModel.isProUser  {
                if !viewModel.prefsRepo.shownParentalGate {
                    activeSheet = .parentalGate
                } else if viewModel.prefsRepo.shownParentalGate && viewModel.prefsRepo.approveShowingPrompt(hours: 5) {
                    activeSheet = .paywall
                }
            }
            #endif
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
                case .parentalGate:
                    ParentalGateView {
                        activeSheet = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.updateParentalGate(value: true)
                            activeSheet = .paywall
                        }
                    }
                    .interactiveDismissDisabled(true)
                
                case .paywall:
                    PaywallView(displayCloseButton: true)
            }
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                HomeSkeleton()
                
            case .filtered:
                TabView {
                    HomeSearch(viewModel: viewModel)
                        .tabItem {
                            Label("Tafuta", systemImage: "magnifyingglass")
                        }
                    
                    LibraryCollectionsView(viewModel: libraryViewModel)
                        .tabItem {
                            Label("Maktaba", systemImage: "books.vertical.fill")
                        }
                    
                    SettingsView(viewModel: viewModel)
                        .tabItem {
                            Label("Mipangilio", systemImage: "gear")
                        }
                }
                .environment(\.horizontalSizeClass, .compact)
                
            case .error(let msg):
                ErrorState(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                HomeSkeleton()
        }
    }
}
