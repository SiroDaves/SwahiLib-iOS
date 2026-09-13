//
//  CollapsingHeader.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

import SwiftUI

struct CollapsingHeader: View {
    var title: String
    var subtitle: String? = nil

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 100)

            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
                    .lineLimit(1)

                if let subtitle = subtitle, !subtitle.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(subtitle)
                        .foregroundColor(.white.opacity(0.85))
                        .italic()
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(1)
                }
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview{
    CollapsingHeader(title: "This is a test")
}
