//
//  HomeTab.swift
//  SwahiLib
//
//  Created by @sirodevs on 05/07/2025.
//

import SwiftUI

enum HomeTab: String, CaseIterable, Identifiable {
    case all
    case words
    case idioms
    case sayings
    case proverbs

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .all: return "yote"
        case .words: return "maneno"
        case .idioms: return "nahau"
        case .sayings: return "misemo"
        case .proverbs: return "methali"
        }
    }
}

let homeTabs: [HomeTab] = [
    .words,
    .idioms,
    .sayings,
    .proverbs
]

/// Used only by Advanced Search's type filter, which additionally offers
/// an "all types" option ("YOTE") ahead of the four specific types.
let advancedSearchTypes: [HomeTab] = [.all] + homeTabs
