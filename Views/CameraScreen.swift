//
//  CameraScreen.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI
import ARKit

struct CameraScreen: View {
    @EnvironmentObject private var store: VocabStore
    @StateObject private var vm = ARCameraViewModel()
    @State private var showDebug = true
    @State private var frameCount = 0
    @State private var fps: Double = 0
    @State private var lastFPSUpdate = Date()

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                ARCameraView(session: vm.session)
                    .ignoresSafeArea()
                if showDebug && !vm.isRunning {
                    Text("Đang khởi tạo camera…")
                        .font(.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 16)
                }
            }

            // DEBUG OVERLAY (on-screen, removable later)
            if showDebug {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text("Vision (Built-in)")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)

                    HStack(spacing: 8) {
                        Text("Label: ")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(vm.englishLabel.isEmpty ? "—" : vm.englishLabel)
                            .font(.caption2)
                            .lineLimit(1)
                    }

                    HStack(spacing: 8) {
                        Text("Confidence:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(Int(vm.confidence * 100))%")
                            .font(.caption2)
                    }

                    HStack(spacing: 8) {
                        Text("FPS:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(String(format: "%.1f", fps))
                            .font(.caption2)
                    }

                    Button(action: { showDebug = false }) {
                        Text("Ẩn debug")
                            .font(.caption2)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.black.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            VStack(spacing: 12) {
                CameraOverlayCard(
                    english: vm.englishLabel,
                    ipa: vm.ipaLabel,
                    vietnamese: vm.vietnameseLabel,
                    confidence: vm.confidence,
                    onAdd: addWord,
                    canAdd: !vm.englishLabel.isEmpty && vm.confidence >= 0.45
                )
            }
            .tabBarAwareBottomPadding(8)
        }
        .onAppear { vm.start() }      // Tự động chạy khi vào tab Camera
        .onDisappear { vm.stop() }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(vm.$englishLabel) { label in
            guard showDebug else { return }
            if !label.isEmpty {
                frameCount += 1
                let now = Date()
                let elapsed = now.timeIntervalSince(lastFPSUpdate)
                if elapsed >= 1.0 {
                    fps = Double(frameCount) / elapsed
                    frameCount = 0
                    lastFPSUpdate = now
                }
            }
        }
    }

    private func addWord() {
        guard !vm.englishLabel.isEmpty, vm.confidence >= 0.45 else { return }
        let word = Word(
            term: vm.englishLabel,
            meaning: vm.vietnameseLabel,
            example: vm.ipaLabel.isEmpty ? nil : vm.ipaLabel
        )
        store.add(word)
    }
}
