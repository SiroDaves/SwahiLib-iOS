//
//  MapCdToEntity.swift
//  SwahiLib
//
//  Created by @sirodevs on 03/07/2025.
//

struct MapCdToEntity {
    static func mapToEntity(_ cd: CDIdiom) -> Idiom {
        Idiom(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            meaning: cd.meaning ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }
    
    static func mapToEntity(_ cd: CDProverb) -> Proverb {
        Proverb(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            synonyms: cd.synonyms ?? "",
            meaning: cd.meaning ?? "",
            conjugation: cd.conjugation ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }
    
    static func mapToEntity(_ cd: CDSaying) -> Saying {
        Saying(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            meaning: cd.meaning ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }
    
    static func mapToEntity(_ cd: CDWord) -> Word {
        Word(
            rid: Int(cd.rid),
            title: cd.title ?? "",
            synonyms: cd.synonyms ?? "",
            meaning: cd.meaning ?? "",
            conjugation: cd.conjugation ?? "",
            english: cd.english ?? "",
            views: Int(cd.views),
            likes: Int(cd.likes),
            liked: cd.liked,
            createdAt: cd.createdAt ?? "",
            updatedAt: cd.updatedAt ?? ""
        )
    }
    
}
