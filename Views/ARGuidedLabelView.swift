//
//  ARGuidedLabelView.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI
import ARKit

struct ARGuidedLabelView: View {
    @StateObject private var vm = ARCameraViewModel()
    @State private var score = 0
    @State private var frameCount = 0
    @State private var fps: Double = 0
    @State private var lastFPSUpdate = Date()

    var body: some View {
        ZStack {
            ARCameraView(session: vm.session).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Main detection label
                VStack(spacing: 4) {
                    Text(vm.englishLabel.isEmpty ? "Đưa vật thể vào khung hình" : "\(vm.englishLabel) – \(vm.vietnameseLabel)")
                        .font(.headline)
                    
                    if vm.confidence > 0 {
                        Text("Confidence: \(Int(vm.confidence * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.bottom, 24)
            }
        }
        .onTapGesture { 
            if vm.confidence >= 0.45 { 
                score += 1
                print("✅ [VISION] Scored! Total: \(score)")
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: 8) {
                // Score
                VStack(spacing: 2) {
                    Text("🏆")
                        .font(.title3)
                    Text("Điểm: \(score)")
                        .font(.headline)
                }
                
                // MODEL INDICATOR - VISION
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(vm.isRunning ? Color.blue : Color.red)
                            .frame(width: 8, height: 8)
                        Text("Vision")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(vm.isRunning ? .blue : .red)
                    
                    // FPS Counter
                    Text("FPS: \(String(format: "%.1f", fps))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .overlay(alignment: .topLeading) {
            // Detection info overlay
            if !vm.englishLabel.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("📱 Vision Framework")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Built-in iOS")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
            }
        }
        .onAppear { 
            vm.start()
            print("🚀 [VISION] ARGuidedLabelView started")
            print("📱 [VISION] Using built-in Vision Framework")
            print("ℹ️  [VISION] Generic image classification")
        }
        .onDisappear { 
            vm.stop() 
            print("🛑 [VISION] ARGuidedLabelView stopped")
        }
        .onReceive(vm.$englishLabel) { label in
            if !label.isEmpty {
                frameCount += 1
                let now = Date()
                let elapsed = now.timeIntervalSince(lastFPSUpdate)
                if elapsed >= 1.0 {
                    fps = Double(frameCount) / elapsed
                    frameCount = 0
                    lastFPSUpdate = now
                    
                    print("📊 [VISION] Detection: '\(label)' (confidence: \(String(format: "%.1f", vm.confidence * 100))%) | FPS: \(String(format: "%.1f", fps))")
                }
            }
        }
    }
}
