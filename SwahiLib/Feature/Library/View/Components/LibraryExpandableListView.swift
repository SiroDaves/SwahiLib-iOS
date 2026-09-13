//
//  LibraryExpandableListView.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct LibraryExpandableListView: View {
    let items: [LibraryDisplayItem]
    let isGrouped: Bool
    let showSideBySide: Bool

    @State private var expandedId: String?

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
            LazyVStack(alignment: .leading, spacing: 0) {
                if isGrouped {
                    ForEach(groupedItems, id: \.group) { section in
                        LibraryGroupHeader(title: section.group)
                        ForEach(section.items) { item in
                            LibraryExpandableItem(
                                item: item,
                                isExpanded: expandedId == item.id,
                                showSideBySide: showSideBySide,
                                onToggle: { toggle(item.id) }
                            )
                        }
                    }
                } else {
                    ForEach(items) { item in
                        LibraryExpandableItem(
                            item: item,
                            isExpanded: expandedId == item.id,
                            showSideBySide: showSideBySide,
                            onToggle: { toggle(item.id) }
                        )
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func toggle(_ id: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            expandedId = expandedId == id ? nil : id
        }
    }
}

private struct LibraryExpandableItem: View {
    let item: LibraryDisplayItem
    let isExpanded: Bool
    let showSideBySide: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.primaryText)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.onSurface)

                    if !isExpanded, let secondary = item.secondaryText, !secondary.isEmpty {
                        Text(secondary)
                            .font(.system(size: 13))
                            .foregroundColor(.onSurface.opacity(0.7))
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.primary1)
            }

            if isExpanded && !item.detailFields.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    ForEach(item.detailFields) { field in
                        if showSideBySide {
                            HStack(alignment: .top, spacing: 5) {
                                Text(field.label)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.primary1)
                                Text(field.value)
                                    .font(.system(size: 15))
                                    .foregroundColor(.onSurface)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(field.label)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.primary1)
                                Text(field.value)
                                    .font(.system(size: 15))
                                    .foregroundColor(.onSurface)
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.surface)
                .shadow(color: .onPrimaryContainer.opacity(0.06), radius: 3, x: 0, y: 1)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}
