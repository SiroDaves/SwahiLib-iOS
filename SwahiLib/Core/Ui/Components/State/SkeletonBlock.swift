//
//  SkeletonBlock.swift
//  SwahiLib
//
//  Reusable shimmering placeholder blocks used to build loading skeletons,
//  replacing the old Lottie-based loaders. Mirrors Android's ShimmerBrush /
//  skeleton components (see feature/home/.../HomeSkeleton.kt).
//

import SwiftUI

/// A single shimmering placeholder shape. Compose several of these to build
/// a skeleton that mirrors the eventual content's layout.
struct SkeletonBlock: View {
    var width: CGFloat? = nil
    var height: CGFloat
    var cornerRadius: CGFloat = 6

    @State private var animate = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    colors: [
                        Color.onSurface.opacity(0.08),
                        Color.onSurface.opacity(0.20),
                        Color.onSurface.opacity(0.08)
                    ],
                    startPoint: animate ? .trailing : .leading,
                    endPoint: animate ? UnitPoint(x: 2, y: 0.5) : UnitPoint(x: -1, y: 0.5)
                )
            )
            .frame(width: width, height: height)
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
    }
}

/// A card-shaped row placeholder mirroring the app's dictionary-entry cards
/// (title + subtitle + a few tag pills), used while lists are loading.
struct EntryRowSkeleton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            SkeletonBlock(width: 4, height: 48, cornerRadius: 2)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    SkeletonBlock(height: 18)
                    Spacer(minLength: 8)
                    SkeletonBlock(width: 16, height: 16, cornerRadius: 8)
                }

                SkeletonBlock(width: 160, height: 14)

                HStack(spacing: 4) {
                    SkeletonBlock(width: 50, height: 16, cornerRadius: 16)
                    SkeletonBlock(width: 40, height: 16, cornerRadius: 16)
                    SkeletonBlock(width: 30, height: 16, cornerRadius: 16)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surface)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
    }
}

/// A generic shimmering list, used as a lightweight loader wherever the
/// eventual content is a list of dictionary entries (search results,
/// library collections, advanced search, first-launch sync).
struct ListSkeleton: View {
    var rowCount: Int = 10

    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                ForEach(0..<rowCount, id: \.self) { _ in
                    EntryRowSkeleton()
                }
            }
            .padding(.top, 8)
        }
        .scrollDisabled(true)
        .allowsHitTesting(false)
    }
}

#Preview {
    ListSkeleton()
}
