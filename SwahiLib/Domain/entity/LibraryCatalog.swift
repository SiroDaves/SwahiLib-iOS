//
//  LibraryCatalog.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Mirrors Android's LibraryKeys/LibraryConfig/LibraryCatalog: a single
//  data-driven list drives both the collection-picker grid and how each
//  collection's screen renders (grid vs. expandable list, grouped
//  sections, side-by-side detail rows).
//

import Foundation

enum LibraryKeys {
    static let caps = "caps"
    static let countries = "countries"
    static let family = "family"
    static let fish = "fish"
    static let greetings = "greetings"
    static let insects = "insects"
    static let kidGames = "kid_games"
    static let punctuation = "punctuation"
    static let seas = "seas"
}

enum LibraryDisplayMode {
    case grid
    case list
}

struct LibraryConfig: Identifiable {
    let key: String
    let title: String
    let subtitle: String
    /// SF Symbol name (Android's equivalent uses a Material icon name).
    let iconName: String
    let displayMode: LibraryDisplayMode
    var numberOfGrids: Int = 3
    var isGrouped: Bool = false
    var sideBySide: Bool = false

    var id: String { key }
}

enum LibraryCatalog {
    static let all: [LibraryConfig] = [
        LibraryConfig(
            key: LibraryKeys.caps,
            title: "Kofia",
            subtitle: "Aina za kofia za jadi",
            iconName: "hat.widebrim",
            displayMode: .grid,
            numberOfGrids: 2
        ),
        LibraryConfig(
            key: LibraryKeys.countries,
            title: "Nchi",
            subtitle: "Nchi za dunia",
            iconName: "globe",
            displayMode: .list,
            isGrouped: true,
            sideBySide: true
        ),
        LibraryConfig(
            key: LibraryKeys.family,
            title: "Jamii",
            subtitle: "Majina ya wanajamii",
            iconName: "person.3",
            displayMode: .grid
        ),
        LibraryConfig(
            key: LibraryKeys.fish,
            title: "Samaki",
            subtitle: "Majina ya Samaki",
            iconName: "fish",
            displayMode: .grid
        ),
        LibraryConfig(
            key: LibraryKeys.greetings,
            title: "Salamu",
            subtitle: "Salamu za kienyeji",
            iconName: "hand.wave",
            displayMode: .list,
            sideBySide: true
        ),
        LibraryConfig(
            key: LibraryKeys.insects,
            title: "Wadudu",
            subtitle: "Aina za wadudu",
            iconName: "ant",
            displayMode: .grid,
            isGrouped: true
        ),
        LibraryConfig(
            key: LibraryKeys.kidGames,
            title: "Michezo ya Watoto",
            subtitle: "Michezo ya asili ya watoto",
            iconName: "die.face.5",
            displayMode: .list
        ),
        LibraryConfig(
            key: LibraryKeys.punctuation,
            title: "Uakifishaji",
            subtitle: "Alama za uakifishaji",
            iconName: "quote.bubble",
            displayMode: .list
        ),
        LibraryConfig(
            key: LibraryKeys.seas,
            title: "Bahari",
            subtitle: "Bahari za dunia",
            iconName: "water.waves",
            displayMode: .list,
            sideBySide: true
        ),
    ]

    static func config(for key: String) -> LibraryConfig? {
        all.first { $0.key == key }
    }
}
