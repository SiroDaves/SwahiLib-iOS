//
//  ScrollOffsetPreferenceKey.swift
//  SwahiLib
//

import SwiftUI

/// Tracks the vertical offset of a marker view placed at the top of a
/// `ScrollView`'s content, so callers can tell whether the user is at the
/// top of the list (mirrors Android's `listState.firstVisibleItemIndex == 0`
/// check used to drive the scroll-to-top FAB and the advanced-search FAB).
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    /// Attach to a zero-height marker at the top of scrollable content.
    /// Reports the marker's offset within `coordinateSpace` via `onChange`.
    func trackScrollOffset(
        coordinateSpace: String,
        onChange: @escaping (CGFloat) -> Void
    ) -> some View {
        self.background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geo.frame(in: .named(coordinateSpace)).minY
                )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
    }
}
