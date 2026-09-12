//
//  StateComponents.swift
//  SwahiLib
//
//  Mirrors Android's StateComponents.kt: ResultCountBadge, EmptySection,
//  and EmptySearchPrompt.
//

import SwiftUI

struct ResultCountBadge: View {
    let query: String
    let count: Int

    var body: some View {
        if !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            HStack(spacing: 6) {
                Text("\(count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.primary2))

                Text("Matokeo")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.onSurface.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
            .transition(.opacity)
        }
    }
}

struct EmptySection: View {
    let category: String

    private var statement: String {
        switch category {
        case "maneno": return "Hamna maneno kulingana na utafutaji wako"
        case "nahau": return "Hamna nahau kulingana na utafutaji wako"
        case "misemo": return "Hamna misemo kulingana na utafutaji wako"
        case "methali": return "Hamna methali kulingana na utafutaji wako"
        default: return "Hamna matokeo kulingana na utafutaji wako"
        }
    }

    var body: some View {
        Text(statement)
            .font(.system(size: 14))
            .foregroundColor(.onSurface.opacity(0.6))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
    }
}

struct EmptySearchPrompt: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.onSurface.opacity(0.25))
                .padding(.bottom, 12)

            Text("Anza kutafuta")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.onSurface.opacity(0.7))

            Text("Andika neno, maana, example au chochote katika kisanduku")
                .font(.system(size: 12))
                .foregroundColor(.onSurface.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
}
