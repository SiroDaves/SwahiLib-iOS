//
//  ProverbMeaning.swift
//  SwahiLib
//
//  Created by @sirodevs on 01/12/2025.
//

import SwiftUI

struct ProverbMeaning: View {
    let meanings: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(meanings.enumerated()), id: \.offset) { index, meaning in
                let parts = meaning.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                let maana = parts.first ?? ""
                let maelezo = parts.count > 1 ? parts[1] : nil

                if !maana.isEmpty {
                    ProverbCardView(
                        maana: maana,
                        maelezo: maelezo,
                        index: index,
                        total: meanings.count
                    )
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

struct ProverbCardView: View {
    let maana: String
    let maelezo: String?
    let index: Int
    let total: Int
    
    private var combinedMarkdown: String {
        var result = ""
        
        if total > 1 {
            result += "\(index + 1). "
        }
        
        result += maana
        
        if let maelezo = maelezo, !maelezo.isEmpty {
            return  "**\(result):** \(maelezo)"
        } else {
            return result
        }
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            markdownView
        } else {
            fallbackView
        }
    }
    
    @available(iOS 15.0, *)
    private var markdownView: some View {
        Text(.init(combinedMarkdown))
            .font(.system(size: 18))
            .foregroundColor(Color(.primary1))
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.background1)
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(2)
    }
    
    private var fallbackView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(total > 1 ? "\(index + 1). " : "")\(maana)")
                .bold()
                .padding(10)
                .font(.system(size: 18))
                .foregroundColor(Color(.primary1))
            
            if let maelezo = maelezo, !maelezo.isEmpty {
                Text(maelezo)
                    .font(.system(size: 18))
                    .foregroundColor(Color(.primary1))
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
    ProverbView(
        proverb: Proverb.sampleProverbs[0]
    )
}
