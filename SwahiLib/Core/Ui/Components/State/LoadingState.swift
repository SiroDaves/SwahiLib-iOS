//
//  LoadingView.swift
//  SwahiLib
//
//  Created by @sirodevs on 04/05/2025.
//

import SwiftUI

struct LoadingState: View {
    var title: String = ""
    var showProgress: Bool = false
    var progressValue: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.onSurface)
            }

            if showProgress {
                VStack(spacing: 8) {
                    HStack {
                        ProgressView(value: Double(progressValue) / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: .primary1))
                            .frame(height: 20)
                        Spacer().frame(width: 8)
                        Text("\(progressValue) %")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.onSurface)
                    }
                }
                .padding(.horizontal)
            }

            ListSkeleton(rowCount: 8)
        }
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    LoadingState(
        title: "Inapakia data ...",
        showProgress: true,
        progressValue: 65,
    )
}
