//
//  SortingComponents.swift
//  SwahiLib
//
//  Mirrors Android's SortDropdown (A→Z / Z→A / Vipendwa kwanza) and
//  TypeFilterRow (YOTE + the four content type chips).
//

import SwiftUI

enum SortOrder: String, CaseIterable {
    case az
    case za
    case likedFirst

    var shortLabel: String {
        switch self {
        case .az: return "A→Z"
        case .za: return "Z→A"
        case .likedFirst: return "♥"
        }
    }
}

struct SortDropdown: View {
    @Binding var sortOrder: SortOrder

    var body: some View {
        Menu {
            Picker("", selection: $sortOrder) {
                Label("A → Z", systemImage: "textformat.abc").tag(SortOrder.az)
                Label("Z → A", systemImage: "textformat.abc").tag(SortOrder.za)
                Label("Vipendwa kwanza", systemImage: "heart").tag(SortOrder.likedFirst)
            }
        } label: {
            HStack(spacing: 2) {
                Text(sortOrder.shortLabel)
                    .font(.system(size: 14, weight: .semibold))
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .semibold))
            }
            .foregroundColor(.onSurface)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
    }
}

struct TypeFilterRow: View {
    @Binding var selected: HomeTab
    var types: [HomeTab] = advancedSearchTypes

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(types) { type in
                    let isSelected = selected == type

                    Button {
                        selected = type
                    } label: {
                        HStack(spacing: 4) {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            Text(type.title.uppercased())
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.primary2.opacity(0.16) : Color.surface)
                        )
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? Color.primary2 : Color.onSurface.opacity(0.2), lineWidth: 1)
                        )
                        .foregroundColor(isSelected ? Color.primary2 : Color.onSurface)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
