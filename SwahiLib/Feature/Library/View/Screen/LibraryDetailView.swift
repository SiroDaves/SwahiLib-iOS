//
//  LibraryDetailView.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct LibraryDetailView: View {
    @ObservedObject var viewModel: LibraryViewModel
    let collectionKey: String

    private var config: LibraryConfig? {
        viewModel.config(for: collectionKey)
    }

    private var items: [LibraryDisplayItem] {
        viewModel.items(for: collectionKey)
    }

    var body: some View {
        Group {
            if let config {
                content(for: config)
                    .navigationTitle(config.title)
            } else {
                Text("Haipatikani")
                    .foregroundColor(.onSurface.opacity(0.7))
            }
        }
        .task { await viewModel.ensureLoaded(collectionKey) }
        .refreshable { await viewModel.refresh(collectionKey) }
    }

    @ViewBuilder
    private func content(for config: LibraryConfig) -> some View {
        if items.isEmpty && viewModel.isSyncing {
            LoadingState(fileName: "circle-loader")
        } else if items.isEmpty {
            EmptyState()
        } else if config.displayMode == .grid {
            LibraryGridView(items: items, isGrouped: config.isGrouped, numberOfGrids: config.numberOfGrids)
        } else {
            LibraryExpandableListView(items: items, isGrouped: config.isGrouped, showSideBySide: config.sideBySide)
        }
    }
}
