//
//  LibraryTileCard.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//

import SwiftUI

struct LibraryTileCard: View {
    let config: LibraryConfig

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: config.iconName)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary1)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(Color.primary1.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(config.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.onPrimaryContainer)
                    .lineLimit(1)

                Text(config.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.onPrimaryContainer.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.background1)
                .shadow(color: .onPrimaryContainer.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}
