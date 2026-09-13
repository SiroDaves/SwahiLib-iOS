//
//  HomeSkeleton.swift
//  SwahiLib
//
//  Full-screen skeleton shown while Home's initial data loads, mirroring
//  Android's HomeSkeleton (search field + type chips + vertical letters +
//  result rows), instead of the old Lottie loading animation.
//

import SwiftUI

struct HomeSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonBlock(height: 44, cornerRadius: 12)
                .padding(.horizontal, 10)

            HStack(spacing: 5) {
                ForEach(0..<4, id: \.self) { _ in
                    SkeletonBlock(width: 80, height: 32, cornerRadius: 16)
                }
            }
            .padding(.leading, 10)

            HStack(alignment: .top, spacing: 10) {
                VStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { _ in
                        SkeletonBlock(width: 55, height: 55, cornerRadius: 15)
                    }
                }
                .frame(width: 60)
                .padding(.leading, 10)

                VStack(spacing: 4) {
                    ForEach(0..<8, id: \.self) { _ in
                        EntryRowSkeleton()
                    }
                }
            }
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HomeSkeleton()
}
