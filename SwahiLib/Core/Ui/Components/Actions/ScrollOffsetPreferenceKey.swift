//
//  ScrollOffsetPreferenceKey.swift
//  SwahiLib
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
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
