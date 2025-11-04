//
//  CameraVocabularyMode.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI
import ARKit

enum DetectionMode: String, CaseIterable {
    case vision = "Vision"
    case yolo = "YOLO"
}

struct CameraVocabularyMode: View {
    @EnvironmentObject private var store: VocabStore
    @StateObject private var vmVision = ARCameraViewModel()
    @StateObject private var vmYOLO = CameraManagerYOLO()
    @State private var detectionMode: DetectionMode = .vision

    var body: some View {
        ZStack(alignment: .bottom) {
            // Show appropriate camera view based on mode
            Group {
                if detectionMode == .vision {
                    ZStack {
                        ARCameraView(session: vmVision.session).ignoresSafeArea()
                        
                        // Crosshair red cho Vision mode
                        GeometryReader { geometry in
                            let screenWidth = geometry.size.width
                            let screenHeight = geometry.size.height
                            let cardHeight: CGFloat = 200
                            let availableHeight = screenHeight - cardHeight - 8
                            let centerX = screenWidth / 2
                            let centerY = availableHeight / 2
                            
                            ZStack {
                                // Horizontal line
                                Rectangle()
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 40, height: 2)
                                    .position(x: centerX, y: centerY)
                                
                                // Vertical line
                                Rectangle()
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 2, height: 40)
                                    .position(x: centerX, y: centerY)
                                
                                // Center circle
                                Circle()
                                    .stroke(Color.red.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: 12, height: 12)
                                    .position(x: centerX, y: centerY)
                            }
                        }
                    }
                } else {
                    ZStack {
                        YOLOCameraPreview(cameraManager: vmYOLO).ignoresSafeArea()
                        
                        // Crosshair và bounding boxes cho YOLO
                        GeometryReader { geometry in
                            // Crosshair (red)
                            let screenWidth = geometry.size.width
                            let screenHeight = geometry.size.height
                            let cardHeight: CGFloat = 200
                            let availableHeight = screenHeight - cardHeight - 8
                            let centerX = screenWidth / 2
                            let centerY = availableHeight / 2
                            
                            ZStack {
                                // Horizontal line
                                Rectangle()
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 40, height: 2)
                                    .position(x: centerX, y: centerY)
                                
                                // Vertical line
                                Rectangle()
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 2, height: 40)
                                    .position(x: centerX, y: centerY)
                                
                                // Center circle
                                Circle()
                                    .stroke(Color.red.opacity(0.6), lineWidth: 1.5)
                                    .frame(width: 12, height: 12)
                                    .position(x: centerX, y: centerY)
                            }
                            
                            // Bounding boxes
                            if let centerObservation = vmYOLO.centerObject {
                                YOLOBoundingBoxView(observation: centerObservation, geometry: geometry)
                            }
                        }
                    }
                }
            }

            VStack(spacing: 10) {
                // Card displays labels from active mode
                CameraOverlayCard(
                    english: activeEnglishLabel,
                    ipa: activeIpaLabel,
                    vietnamese: activeVietnameseLabel,
                    confidence: activeConfidence,
                    onAdd: addWord,
                    canAdd: !activeEnglishLabel.isEmpty && activeConfidence >= 0.45
                )

                HStack(spacing: 8) {
                    // Toggle button để chuyển đổi Vision/YOLO
                    Button {
                        toggleMode()
                    } label: {
                        Label(detectionMode.rawValue, systemImage: "arrow.triangle.swap")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.black.opacity(0.25))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        TTSService.shared.speak(activeEnglishLabel, lang: "en-US")
                    } label: {
                        Label("Nghe phát âm", systemImage: "speaker.wave.2.fill")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(Color.black.opacity(0.25))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    .disabled(activeEnglishLabel.isEmpty)
                }
            }
            .tabBarAwareBottomPadding(0)
        }
        .onAppear {
            // Chỉ start mode hiện tại để tránh xung đột camera
            if detectionMode == .vision {
                vmVision.start()
            } else {
                vmYOLO.start()
            }
        }
        .onDisappear {
            vmVision.stop()
            vmYOLO.stop()
        }
        .onChange(of: detectionMode) { newMode in
            // Khi mode thay đổi, stop/pause mode cũ trước
            if newMode == .vision {
                vmYOLO.stop()
                vmVision.start()
            } else {
                vmVision.stop()
                vmYOLO.start()
            }
        }
    }
    
    // Computed properties for active labels based on mode
    private var activeEnglishLabel: String {
        detectionMode == .vision ? vmVision.englishLabel : vmYOLO.englishLabel
    }
    
    private var activeVietnameseLabel: String {
        detectionMode == .vision ? vmVision.vietnameseLabel : vmYOLO.vietnameseLabel
    }
    
    private var activeIpaLabel: String {
        detectionMode == .vision ? vmVision.ipaLabel : vmYOLO.ipaLabel
    }
    
    private var activeConfidence: Double {
        detectionMode == .vision ? vmVision.confidence : vmYOLO.confidence
    }
    
    private func toggleMode() {
        // Chỉ toggle mode, onChange sẽ xử lý start/stop
        detectionMode = detectionMode == .vision ? .yolo : .vision
        print("🔄 Switched to: \(detectionMode.rawValue)")
    }

    private func addWord() {
        guard !activeEnglishLabel.isEmpty, activeConfidence >= 0.45 else { return }
        let word = Word(
            term: activeEnglishLabel,
            meaning: activeVietnameseLabel,
            example: activeIpaLabel.isEmpty ? nil : activeIpaLabel
        )
        store.add(word)
    }
}
