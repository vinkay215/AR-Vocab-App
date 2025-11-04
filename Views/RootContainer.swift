//
//  RootContainer.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct RootContainer: View {
    @State private var selection: AppTab = .home

    var body: some View {
        ZStack {
            switch selection {
            case .home:    HomeView()
            case .camera:  CameraVocabularyMode()
            case .explore: OCRFlashcardView()
            case .profile: ProfileView()
            }
        }
        // Không dùng safeAreaInset; đặt overlay dính đáy và không thêm padding ngoài
        .overlay(alignment: .bottom) {
            CustomTabBar(selection: $selection)
        }
    }
}
