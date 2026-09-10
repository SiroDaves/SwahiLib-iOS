//
//  LibraryDisplayItem.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Every maktaba collection (caps, countries, family, fish, greetings,
//  insects, kid games, punctuation, seas) has its own JSON shape, but they
//  all render the same way: a primary line, an optional secondary line,
//  an optional group header, and an expandable set of label/value detail
//  fields. LibraryMapper converts each collection's raw JSON into this one
//  shape, mirroring Android's `LibraryDisplayItem` + per-entity
//  `toDisplayItem()` mappers.
//

import Foundation

struct LibraryDetailField: Identifiable, Hashable, Codable {
    var id: String { label }
    let label: String
    let value: String
}

struct LibraryDisplayItem: Identifiable, Hashable {
    let id: String
    var groupName: String?
    let primaryText: String
    var secondaryText: String?
    var detailFields: [LibraryDetailField] = []
    var orderIndex: Int = 0
}
