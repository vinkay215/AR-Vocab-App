//
//  ARGuidedLabelViewYOLO.swift
//  VocabApp
//
//  Created by AI Assistant on 25/10/2025.
//  AR View with YOLO11n Detection
//

import SwiftUI
import ARKit

struct ARGuidedLabelViewYOLO: View {
    @StateObject private var vm = ARCameraViewModelYOLO()
    @State private var score = 0
    @State private var showInfo = false
    @State private var frameCount = 0
    @State private var fps: Double = 0
    @State private var lastFPSUpdate = Date()

    var body: some View {
        ZStack {
            ZStack {
                ARCameraView(session: vm.session).ignoresSafeArea()
                DetectionOverlay(detections: vm.detections)
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                
                // Main detection label
                VStack(spacing: 8) {
                    if vm.englishLabel.isEmpty {
                        Text("🎯 Đưa vật thể vào khung hình")
                            .font(.headline)
                    } else {
                        VStack(spacing: 4) {
                            Text(vm.englishLabel)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(vm.vietnameseLabel)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(vm.ipaLabel)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Confidence bar
                    if vm.confidence > 0 {
                        HStack(spacing: 4) {
                            Text("Độ chính xác:")
                                .font(.caption)
                            ProgressView(value: vm.confidence, total: 1.0)
                                .frame(width: 100)
                            Text("\(Int(vm.confidence * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.bottom, 32)
            }
        }
        .onTapGesture {
            if vm.confidence >= 0.45 {
                score += 1
                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
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
                
                // YOLO badge
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(vm.isRunning ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text("YOLO11n")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(vm.isRunning ? .green : .red)
                    
                    // FPS Counter
                    Text("FPS: \(String(format: "%.1f", fps))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Info button
                Button(action: { showInfo.toggle() }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 4) {
                if !vm.englishLabel.isEmpty {
                    Text("📍 Nhấn màn hình")
                        .font(.caption)
                    Text("để ghi điểm")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Divider()
                        .padding(.vertical, 4)
                }
                
                // YOLO Model Info
                Text("🤖 YOLO11n")
                    .font(.caption)
                    .fontWeight(.semibold)
                Text("Ultralytics")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("80+ Classes")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
        }
        .sheet(isPresented: $showInfo) {
            NavigationView {
                VStack(spacing: 20) {
                    Image(systemName: "cube.transparent")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("YOLO11n Object Detection")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(icon: "eye", title: "Real-time Detection", description: "Nhận diện vật thể thời gian thực")
                        InfoRow(icon: "brain", title: "AI-Powered", description: "Sử dụng YOLO11n model")
                        InfoRow(icon: "book", title: "Vocabulary Learning", description: "Học từ vựng qua AR")
                        InfoRow(icon: "target", title: "High Accuracy", description: "Độ chính xác cao với 80+ classes")
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Thông tin")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Đóng") {
                            showInfo = false
                        }
                    }
                }
            }
        }
        .onAppear { 
            vm.start()
            print("🚀 [YOLO VIEW] ARGuidedLabelViewYOLO started")
            print("🤖 [YOLO VIEW] Using YOLO11n model")
            print("ℹ️  [YOLO VIEW] Real-time object detection with bounding boxes")
        }
        .onDisappear { 
            vm.stop() 
            print("🛑 [YOLO VIEW] ARGuidedLabelViewYOLO stopped")
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
                    
                    print("📊 [YOLO] Detection: '\(label)' → '\(vm.vietnameseLabel)' (confidence: \(String(format: "%.1f", vm.confidence * 100))%) | FPS: \(String(format: "%.1f", fps))")
                }
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// Preview - uncomment if using Xcode 15+
// #Preview {
//     ARGuidedLabelViewYOLO()
// }

