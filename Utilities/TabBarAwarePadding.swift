//
//  TabBarAwarePadding.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI

// Chiều cao phần nội dung của CustomTabBar theo thiết kế Figma
private let kTabBarContentHeight: CGFloat = 65

// Tổng chiều cao overlay tabbar = content + bottom safe area (home indicator)
func tabBarOverlayHeight() -> CGFloat {
    kTabBarContentHeight + bottomSafeAreaInset()
}

extension View {
    // Dùng thay cho padding(.bottom, X) để tránh bị tabbar che
    func tabBarAwareBottomPadding(_ extra: CGFloat = 0) -> some View {
        self.padding(.bottom, tabBarOverlayHeight() + extra)
    }
}
