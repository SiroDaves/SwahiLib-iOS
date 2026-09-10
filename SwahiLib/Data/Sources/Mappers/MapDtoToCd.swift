//
//  MapDtoToCd.swift
//  SwahiLib
//
//  Created by @sirodevs on 17/12/2025.
//  Updated for the Kamusi content API: views/likes/createdAt/updatedAt no
//  longer come from the remote source (the new API doesn't track them),
//  so they're left at their Core Data defaults on freshly-fetched records.
//

struct MapDtoToCd {
    static func mapToCd(_ dto: IdiomDTO, _ cd: CDIdiom) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
    }

    static func mapToCd(_ dto: ProverbDTO, _ cd: CDProverb) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.synonyms = dto.synonyms
        cd.meaning = dto.meaning
        cd.conjugation = dto.conjugation
    }

    static func mapToCd(_ dto: SayingDTO, _ cd: CDSaying) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
    }
    
    static func mapToCd(_ dto: WordDTO, _ cd: CDWord) {
        cd.rid = Int32(dto.rid)
        cd.title = dto.title
        cd.meaning = dto.meaning
        cd.conjugation = dto.conjugation
        cd.synonyms = dto.synonyms
        cd.english = dto.english
    }
}
