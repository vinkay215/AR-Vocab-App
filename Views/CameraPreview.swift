//
//  CameraPreview.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let layer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        layer.frame = uiView.bounds
    }
}
