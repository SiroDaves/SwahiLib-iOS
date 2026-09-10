//
//  LibraryGridView.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct LibraryGridView: View {
    let items: [LibraryDisplayItem]
    let isGrouped: Bool
    let numberOfGrids: Int

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: numberOfGrids)
    }

    private var groupedItems: [(group: String, items: [LibraryDisplayItem])] {
        var order: [String] = []
        var byGroup: [String: [LibraryDisplayItem]] = [:]
        for item in items {
            let group = item.groupName ?? ""
            if byGroup[group] == nil {
                byGroup[group] = []
                order.append(group)
            }
            byGroup[group]?.append(item)
        }
        return order.map { ($0, byGroup[$0] ?? []) }
    }

    var body: some View {
        ScrollView {
            if isGrouped {
                LazyVStack(alignment: .leading, spacing: 4, pinnedViews: []) {
                    ForEach(groupedItems, id: \.group) { section in
                        LibraryGroupHeader(title: section.group)
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(section.items) { item in
                                LibraryGridItemCard(item: item)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .padding(.vertical, 12)
            } else {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(items) { item in
                        LibraryGridItemCard(item: item)
                    }
                }
                .padding(12)
            }
        }
    }
}

private struct LibraryGridItemCard: View {
    let item: LibraryDisplayItem

    var body: some View {
        VStack(spacing: 2) {
            Text(item.primaryText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.onSurface)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if let secondary = item.secondaryText, !secondary.isEmpty {
                Text(secondary)
                    .font(.system(size: 12))
                    .foregroundColor(.onSurface.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.surface.opacity(0.5))
        )
    }
}
