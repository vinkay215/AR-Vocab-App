//
//  KidsModeView.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI
import ARKit

struct KidsModeView: View {
    @StateObject private var vm = ARCameraViewModel()
    @State private var story = ""

    var body: some View {
        ZStack {
            ARCameraView(session: vm.session).ignoresSafeArea()
            VStack {
                Spacer()
                Text(story.isEmpty ? "Chỉ camera vào đồ chơi" : story)
                    .font(.title3)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
            }
        }
        // Sửa: onChange nhận 1 tham số (newValue), không phải 2
        .onChange(of: vm.englishLabel) { _ in
            guard !vm.englishLabel.isEmpty else { return }
            story = KidsStoryService.makeStory(with: vm.englishLabel, meaning: vm.vietnameseLabel)
        }
        .onAppear { vm.start() }
        .onDisappear { vm.stop() }
    }
}
