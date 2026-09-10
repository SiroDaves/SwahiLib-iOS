//
//  LibraryMapper.swift
//  SwahiLib
//
//  Created by @sirodevs on 07/09/2026.
//
//  Mirrors Android's `LibraryMapper` + per-entity `toDisplayItem()`
//  combined into one step: each maktaba collection has its own JSON shape
//  (flat array, category-grouped object, nested usage arrays, ...), but
//  they all resolve straight to `LibraryDisplayItem` since iOS stores
//  library content in one generic table instead of nine typed ones.
//

import Foundation

enum LibraryMapper {
    // MARK: - Helpers

    private static func parseJson(_ rawJson: String) -> Any? {
        guard let data = rawJson.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data)
    }

    private static func str(_ any: Any?) -> String? {
        guard let s = any as? String, !s.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return s
    }

    private static func rid(_ obj: [String: Any], index: Int) -> String {
        if let value = str(obj["rid"]) { return value }
        if let number = obj["rid"] as? NSNumber { return number.stringValue }
        return "\(index + 1)"
    }

    /// Maps a collection key to its parsing function. Returns `nil` items on
    /// any failure so a bad payload doesn't crash the sync.
    static func map(collectionKey: String, rawJson: String) -> [LibraryDisplayItem] {
        switch collectionKey {
        case LibraryKeys.caps: return mapSimple(rawJson, primary: "title", secondary: "meaning", secondaryLabel: "Maana")
        case LibraryKeys.family: return mapSimple(rawJson, primary: "title", secondary: "meaning", secondaryLabel: "Maana")
        case LibraryKeys.fish: return mapFish(rawJson)
        case LibraryKeys.insects: return mapInsects(rawJson)
        case LibraryKeys.seas: return mapSeas(rawJson)
        case LibraryKeys.kidGames: return mapKidGames(rawJson)
        case LibraryKeys.greetings: return mapGreetings(rawJson)
        case LibraryKeys.countries: return mapCountries(rawJson)
        case LibraryKeys.punctuation: return mapPunctuation(rawJson)
        default: return []
        }
    }

    // MARK: - Flat-array collections (title + optional meaning)

    private static func mapSimple(_ rawJson: String, primary: String, secondary: String, secondaryLabel: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            let meaning = str(obj[secondary])
            return LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: str(obj[primary]) ?? "",
                secondaryText: meaning,
                detailFields: meaning.map { [LibraryDetailField(label: secondaryLabel, value: $0)] } ?? [],
                orderIndex: index
            )
        }
    }

    private static func mapFish(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: str(obj["title"]) ?? "",
                orderIndex: index
            )
        }
    }

    // MARK: - Category-grouped object collections

    private static func mapInsects(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let root = parseJson(rawJson) as? [String: [[String: Any]]] else { return [] }
        var items: [LibraryDisplayItem] = []
        var order = 0
        for (category, arr) in root {
            for obj in arr {
                items.append(LibraryDisplayItem(
                    id: rid(obj, index: order),
                    groupName: category,
                    primaryText: str(obj["title"]) ?? "",
                    orderIndex: order
                ))
                order += 1
            }
        }
        return items
    }

    private static func mapCountries(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let root = parseJson(rawJson) as? [String: [[String: Any]]] else { return [] }
        var items: [LibraryDisplayItem] = []
        var order = 0
        for (continent, arr) in root {
            for obj in arr {
                let language = (obj["language"] as? [Any])?
                    .compactMap { $0 as? String }
                    .joined(separator: ", ")
                let currencyObj = obj["currency"] as? [String: Any]
                let currency = str(currencyObj?["title"])
                let currCode = str(currencyObj?["kodi"])
                let english = str(obj["english"])

                items.append(LibraryDisplayItem(
                    id: rid(obj, index: order),
                    groupName: continent,
                    primaryText: str(obj["countries"]) ?? "",
                    secondaryText: english,
                    detailFields: [
                        english.map { LibraryDetailField(label: "Kiingereza", value: $0) },
                        str(obj["nationality"]).map { LibraryDetailField(label: "Utaifa", value: $0) },
                        str(obj["capital"]).map { LibraryDetailField(label: "Mji Mkuu", value: $0) },
                        language.flatMap { $0.isEmpty ? nil : LibraryDetailField(label: "Lugha", value: $0) },
                        currency.map { LibraryDetailField(label: "Sarafu", value: currCode != nil ? "\($0) (\(currCode!))" : $0) },
                        str(obj["kodi"]).map { LibraryDetailField(label: "Kodi ya Countries", value: $0) },
                    ].compactMap { $0 },
                    orderIndex: order
                ))
                order += 1
            }
        }
        return items
    }

    // MARK: - Bespoke shapes

    private static func mapSeas(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            let size = str(obj["size"])
            let depth = str(obj["depth"])
            return LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: str(obj["title"]) ?? "",
                secondaryText: size.map { "Ukubwa: \($0) km\u{00B2}" },
                detailFields: [
                    size.map { LibraryDetailField(label: "Ukubwa (km\u{00B2})", value: $0) },
                    depth.map { LibraryDetailField(label: "Kina (m)", value: $0) },
                ].compactMap { $0 },
                orderIndex: index
            )
        }
    }

    private static func mapKidGames(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            let meaning = str(obj["meaning"])
            let reason = str(obj["reason"])
            return LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: str(obj["title"]) ?? "",
                secondaryText: reason,
                detailFields: [
                    meaning.map { LibraryDetailField(label: "Maelezo", value: $0) },
                    reason.map { LibraryDetailField(label: "Lengo", value: $0) },
                ].compactMap { $0 },
                orderIndex: index
            )
        }
    }

    private static func mapGreetings(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            let answer = str(obj["answer"])
            let person1 = str(obj["person1"])
            let person2 = str(obj["person2"])
            let time = str(obj["time"])
            return LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: str(obj["greeting"]) ?? "",
                secondaryText: answer.map { "Kiitikio: \($0)" },
                detailFields: [
                    answer.map { LibraryDetailField(label: "Kiitikio", value: $0) },
                    person1.map { LibraryDetailField(label: "Anayesalimia", value: $0) },
                    person2.map { LibraryDetailField(label: "Anayesalimiwa", value: $0) },
                    time.map { LibraryDetailField(label: "Wakati", value: $0) },
                ].compactMap { $0 },
                orderIndex: index
            )
        }
    }

    private static func mapPunctuation(_ rawJson: String) -> [LibraryDisplayItem] {
        guard let array = parseJson(rawJson) as? [[String: Any]] else { return [] }
        return array.enumerated().map { index, obj in
            let sign = str(obj["sign"]) ?? ""
            let title = str(obj["title"]) ?? ""
            let meaningArr = (obj["meaning"] as? [[String: Any]]) ?? []

            let fields: [LibraryDetailField] = meaningArr.enumerated().flatMap { usageIndex, mObj -> [LibraryDetailField] in
                guard let usage = str(mObj["usage"]) else { return [] }
                var pair = [LibraryDetailField(label: "Matumizi \(usageIndex + 1)", value: usage)]
                if let example = str(mObj["example"]) {
                    pair.append(LibraryDetailField(label: "Mfano \(usageIndex + 1)", value: example))
                }
                return pair
            }

            return LibraryDisplayItem(
                id: rid(obj, index: index),
                primaryText: [sign, title].filter { !$0.isEmpty }.joined(separator: "  "),
                secondaryText: title,
                detailFields: fields,
                orderIndex: index
            )
        }
    }
}
