//
//  AdvancedSearchFAB.swift
//  SwahiLib
//

import SwiftUI

/// Floating action button that opens Advanced Search.
/// Mirrors Android's `ExtendedFloatingActionButton`: shows icon + label
/// while at the top of the list, and collapses to an icon-only pill once
/// the user scrolls down.
struct AdvancedSearchFAB: View {
    var expanded: Bool

    var body: some View {
        NavigationLink {
            AdvancedSearch()
        } label: {
            HStack(spacing: expanded ? 8 : 0) {
                Image(systemName: "text.magnifyingglass")
                    .font(.system(size: 20, weight: .semibold))

                if expanded {
                    Text("TAFUTA KWA KINA")
                        .font(.system(size: 14, weight: .bold))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: .leading)))
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, expanded ? 20 : 14)
            .background(
                Capsule()
                    .fill(Color.primary2)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: expanded)
    }
}

#Preview {
    VStack(spacing: 16) {
        AdvancedSearchFAB(expanded: true)
        AdvancedSearchFAB(expanded: false)
    }
}
