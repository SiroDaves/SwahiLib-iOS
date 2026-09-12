//
//  SearchModeMenu.swift
//  SwahiLib
//
//  Mirrors Android's SearchModeMenu: a "Tune" icon that opens a menu of
//  match-position options, with a checkmark against the current selection.
//

import SwiftUI

enum SearchMode: String, CaseIterable {
    case beginning
    case middle
    case end
}

struct SearchModeMenu: View {
    @Binding var searchMode: SearchMode

    var body: some View {
        Menu {
            Picker("", selection: $searchMode) {
                Text("Tafuta Mwanzo wa Maneno").tag(SearchMode.beginning)
                Text("Tafuta Katikati ya Maneno").tag(SearchMode.middle)
                Text("Tafuta Mwisho wa Maneno").tag(SearchMode.end)
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
        .accessibilityLabel("Chaguo za utafutaji")
    }
}
