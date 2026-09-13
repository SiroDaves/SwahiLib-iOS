//
//  LibraryCollectionsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct LibraryCollectionsView: View {
    @ObservedObject var viewModel: LibraryViewModel

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.collections) { config in
                        NavigationLink {
                            LibraryDetailView(viewModel: viewModel, collectionKey: config.key)
                        } label: {
                            LibraryTileCard(config: config)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .navigationTitle("Maktaba")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
