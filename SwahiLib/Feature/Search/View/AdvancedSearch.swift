//
//  AdvancedSearch.swift
//  SwahiLib
//
//  Created by @sirodevs on 25/10/2025.
//

import SwiftUI
import RevenueCatUI

struct AdvancedSearch: View {
    @StateObject private var viewModel: SearchViewModel = {
        DiContainer.shared.resolve(SearchViewModel.self)
    }()
    @Environment(\.dismiss) private var dismiss
    @State private var showAlertDialog = false
    @State private var showPaywall: Bool = false
    
    var body: some View {
        stateContent
            .edgesIgnoringSafeArea(.bottom)
            .task { viewModel.fetchData() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading:
            LoadingState(
                title: "Inapakia data ..."
            )
            
        case .filtered:
            AdvancedSearchView(viewModel: viewModel)
                .alert("Kipengele hiki cha PRO",
                       isPresented: $viewModel.showAlertDialog
                ) {
                    proLimitAlertButtons
                } message: {
                    Text("Tafadhali jiunge na SwahiLib Pro ili uweze kutumia kipengele hiki.")
                }
                .sheet(isPresented: $showPaywall) {
                #if !DEBUG
                PaywallView(displayCloseButton: true)
                #endif
                }
            
        case .error(let msg):
            ErrorState(message: msg) {
                Task { viewModel.fetchData() }
            }
            
        default:
            LoadingState(
                title: "Inapakia data ..."
            )
        }
    }
    
    private var proLimitAlertButtons: some View {
        Group {
            Button("GHAIRI", role: .cancel) {
                dismiss()
            }
            Button("SAWA") {
                showPaywall = true
            }
        }
    }
    
}
