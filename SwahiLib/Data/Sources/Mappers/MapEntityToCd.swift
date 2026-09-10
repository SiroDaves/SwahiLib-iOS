//
//  MapEntityToCd.swift
//  SwahiLib
//
//  Created by @sirodevs on 03/07/2025.
//

struct MapEntityToCd {
    static func mapToCd(_ entity: Idiom, _ cd: CDIdiom) {
        cd.rid = Int32(entity.rid)
        cd.title = entity.title
        cd.meaning = entity.meaning
        cd.views = Int32(entity.views)
        cd.likes = Int32(entity.likes)
        cd.liked = entity.liked
        cd.createdAt = entity.createdAt
        cd.updatedAt = entity.updatedAt
    }

    static func mapToCd(_ entity: Proverb, _ cd: CDProverb) {
        cd.rid = Int32(entity.rid)
        cd.title = entity.title
        cd.synonyms = entity.synonyms
        cd.meaning = entity.meaning
        cd.conjugation = entity.conjugation
        cd.views = Int32(entity.views)
        cd.likes = Int32(entity.likes)
        cd.liked = entity.liked
        cd.createdAt = entity.createdAt
        cd.updatedAt = entity.updatedAt
    }

    static func mapToCd(_ entity: Saying, _ cd: CDSaying) {
        cd.rid = Int32(entity.rid)
        cd.title = entity.title
        cd.meaning = entity.meaning
        cd.views = Int32(entity.views)
        cd.likes = Int32(entity.likes)
        cd.liked = entity.liked
        cd.createdAt = entity.createdAt
        cd.updatedAt = entity.updatedAt
    }
    
    static func mapToCd(_ entity: Word, _ cd: CDWord) {
        cd.rid = Int32(entity.rid)
        cd.title = entity.title
        cd.synonyms = entity.synonyms
        cd.meaning = entity.meaning
        cd.conjugation = entity.conjugation
        cd.english = entity.english
        cd.views = Int32(entity.views)
        cd.likes = Int32(entity.likes)
        cd.liked = entity.liked
        cd.createdAt = entity.createdAt
        cd.updatedAt = entity.updatedAt
    }
}
