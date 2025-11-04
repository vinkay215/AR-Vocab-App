//
//  ARCameraView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI
import ARKit

struct ARCameraView: UIViewRepresentable {
    let session: ARSession

    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.automaticallyUpdatesLighting = true
        view.rendersContinuously = true
        view.session = session
        view.scene = SCNScene()
        // Reduce render FPS to improve performance on older devices
        view.preferredFramesPerSecond = 30
        view.contentScaleFactor = UIScreen.main.scale
        return view
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) { }
}
