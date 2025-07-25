//
//  SupabaseService.swift
//  SwahiLib
//
//  Created by Siro Daves on 21/06/2025.
//

import Foundation
import Supabase

protocol SupabaseServiceProtocol {
    var client: SupabaseClient { get }
}

final class SupabaseService: SupabaseServiceProtocol {
    let client: SupabaseClient

    init() {
        let urlString = SupabaseSecrets.url
        let anonKey = SupabaseSecrets.anonKey

        guard let url = URL(string: urlString), !anonKey.isEmpty else {
            fatalError("Invalid Supabase URL or anon key. Check Secrets.plist.")
        }

        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
    }
}
