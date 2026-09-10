//
//  MapDtoToEntity.swift
//  SwahiLib
//
//  Created by @sirodevs on 03/07/2025.
//  Updated for the Kamusi content API DTOs (views/likes/createdAt/updatedAt
//  no longer exist on the DTOs — see MapDtoToCd for the same change).
//

struct MapDtoToEntity {
    static func mapToEntity(_ dto: IdiomDTO) -> Idiom {
        Idiom(
            rid: dto.rid,
            title: dto.title ?? "",
            meaning: dto.meaning ?? "",
            views: 0,
            likes: 0,
            liked: false,
            createdAt: "",
            updatedAt: ""
        )
    }

    static func mapToEntity(_ dto: ProverbDTO) -> Proverb {
        Proverb(
            rid: dto.rid,
            title: dto.title ?? "",
            synonyms: dto.synonyms ?? "",
            meaning: dto.meaning ?? "",
            conjugation: dto.conjugation ?? "",
            views: 0,
            likes: 0,
            liked: false,
            createdAt: "",
            updatedAt: ""
        )
    }

    static func mapToEntity(_ dto: SayingDTO) -> Saying {
        Saying(
            rid: dto.rid,
            title: dto.title ?? "",
            meaning: dto.meaning ?? "",
            views: 0,
            likes: 0,
            liked: false,
            createdAt: "",
            updatedAt: ""
        )
    }

    static func mapToEntity(_ dto: WordDTO) -> Word {
        Word(
            rid: dto.rid,
            title: dto.title ?? "",
            synonyms: dto.synonyms ?? "",
            meaning: dto.meaning ?? "",
            conjugation: dto.conjugation ?? "",
            english: dto.english ?? "",
            views: 0,
            likes: 0,
            liked: false,
            createdAt: "",
            updatedAt: ""
        )
    }
}
