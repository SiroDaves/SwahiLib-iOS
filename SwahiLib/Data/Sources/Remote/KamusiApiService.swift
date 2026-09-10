//
//  KamusiApiService.swift
//  SwahiLib
//
//  Replaces SupabaseService as the content backend. Mirrors the Android
//  `KamusiApi`: the content endpoints are static JSON files (not a
//  paginated/queryable REST API), fronted by ETag caching so unchanged
//  content never needs to be re-downloaded.
//

import Foundation

protocol KamusiApiServiceProtocol {
    /// Checks whether an endpoint's content has changed since `storedETag`.
    /// Returns the new ETag if it changed (HTTP 200), or `nil` if unchanged
    /// (HTTP 304) or the check failed.
    func fetchETag(_ endpoint: KamusiEndpoint, storedETag: String?) async -> String?

    /// Fetches and decodes an endpoint's full JSON array.
    /// Returns `nil` on any network/decoding failure.
    func fetchJson<T: Decodable>(_ endpoint: KamusiEndpoint) async -> [T]?
}

/// Content endpoints served as flat, static JSON files.
enum KamusiEndpoint: String, CaseIterable {
    case words = "kamusi/words.json"
    case idioms = "kamusi/idioms.json"
    case proverbs = "kamusi/proverbs.json"
    case sayings = "kamusi/sayings.json"

    var path: String { rawValue }

    /// Key used to persist this endpoint's ETag in PrefsRepo.
    var prefKey: String {
        switch self {
        case .words: return "etag_words"
        case .idioms: return "etag_idioms"
        case .proverbs: return "etag_proverbs"
        case .sayings: return "etag_sayings"
        }
    }
}

enum KamusiApiError: LocalizedError {
    case fetchFailed(KamusiEndpoint)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let endpoint):
            return "Failed to fetch \(endpoint.path)"
        }
    }
}

final class KamusiApiService: KamusiApiServiceProtocol {
    private let session: URLSession
    private let baseURL: URL

    init(session: URLSession = .shared, baseURL: URL = URL(string: AppConstants.kamusiApiBaseURL)!) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchETag(_ endpoint: KamusiEndpoint, storedETag: String?) async -> String? {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        if let storedETag {
            request.setValue(storedETag, forHTTPHeaderField: "If-None-Match")
        }

        do {
            let (_, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { return nil }

            switch http.statusCode {
            case 304:
                print("✅ \(endpoint.path) unchanged (304)")
                return nil
            case 200:
                let etag = http.value(forHTTPHeaderField: "ETag")
                print("🔄 \(endpoint.path) changed — new ETag: \(etag ?? "none")")
                return etag
            default:
                print("⚠️ \(endpoint.path) unexpected status \(http.statusCode)")
                return nil
            }
        } catch {
            print("❌ ETag check failed for \(endpoint.path): \(error.localizedDescription)")
            return nil
        }
    }

    func fetchJson<T: Decodable>(_ endpoint: KamusiEndpoint) async -> [T]? {
        let request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                print("❌ \(endpoint.path) fetch failed")
                return nil
            }
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("❌ JSON fetch failed for \(endpoint.path): \(error.localizedDescription)")
            return nil
        }
    }
}
