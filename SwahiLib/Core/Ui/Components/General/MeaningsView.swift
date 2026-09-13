//
//  MeaningsView.swift
//  SwahiLib
//
//  Created by @sirodevs on 02/08/2025.
//

import SwiftUI

struct MeaningsView: View {
    let meanings: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(meanings.enumerated()), id: \.offset) { index, meaning in
                let parts = meaning.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                let maana = parts.first ?? ""
                let mfano = parts.count > 1 ? parts[1] : nil

                if !maana.isEmpty {
                    CardView(
                        maana: maana,
                        mfano: mfano,
                        index: index,
                        total: meanings.count
                    )
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct CardView: View {
    let maana: String
    let mfano: String?
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(total > 1 ? "\(index + 1). " : "")\(maana)")
                .font(.system(size: 22))
                .foregroundColor(Color(.primary1))
                .padding(.leading, 5)
                .padding(.bottom, mfano != nil ? 8 : 0)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let mfano = mfano, !mfano.isEmpty {
                Divider()
                    .background(Color(.onPrimaryContainer).opacity(0.3))
                    .padding(.bottom, 8)

                HStack {
                    Text("Mfano: ")
                        .bold()
                    Text(mfano)
                        .italic()
                }
                .font(.system(size: 18))
                .foregroundColor(.onPrimaryContainer)
                .padding(.leading, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .background(.background1)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(2)
    }
}

#Preview{
    WordView(
        deepLinked: false, word: Word.sampleWords[0]
    )
}
