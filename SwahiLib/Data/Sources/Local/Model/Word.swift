//
//  Word.swift
//  SwahiLib
//
//  Created by @sirodevs on 30/04/2025.
//

import Foundation

struct Word: Identifiable, Codable, Hashable {
    var id: Int { rid }
    let rid: Int
    let title: String
    let synonyms: String
    let meaning: String
    let conjugation: String
    let english: String
    let views: Int
    let likes: Int
    var liked: Bool
    let createdAt: String
    let updatedAt: String
}
