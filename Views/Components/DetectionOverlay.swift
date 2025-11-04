//
//  DetectionOverlay.swift
//  VocabApp
//
//  Draws YOLO bounding boxes over ARCameraView
//

import SwiftUI

struct DetectionOverlay: View {
    let detections: [DetectedObject]
    let labelColor: Color = .blue

    private func rect(from bbox: CGRect, in size: CGSize) -> CGRect {
        // VNRecognizedObjectObservation.boundingBox is normalized in Vision coordinates (origin at bottom-left)
        let w = bbox.width * size.width
        let h = bbox.height * size.height
        let x = bbox.minX * size.width
        let y = (1.0 - bbox.minY - bbox.height) * size.height
        return CGRect(x: x, y: y, width: w, height: h)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Array(detections.enumerated()), id: \.offset) { _, det in
                    let r = rect(from: det.boundingBox, in: geo.size)
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(labelColor, lineWidth: 2)
                            .frame(width: r.width, height: r.height)
                            .position(x: r.midX, y: r.midY)

                        Text("\(det.className) \(Int(det.confidence * 100))")
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(labelColor.opacity(0.9))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .position(x: r.minX + 6 + 40, y: r.minY - 10) // offset near top-left
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}



