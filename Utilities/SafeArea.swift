//
//  SafeArea.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import UIKit

// Lấy bottom safe area cho iOS 16+
func bottomSafeAreaInset() -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    let insets = scenes.compactMap { $0 as? UIWindowScene }
        .compactMap { scene in scene.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom }
    return insets.max() ?? 0
}
