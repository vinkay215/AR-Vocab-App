//
//  CameraViewModel.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import Foundation
import AVFoundation
import Vision

final class CameraViewModel: NSObject, ObservableObject {
    @Published var currentLabel: String = ""
    @Published var currentConfidence: Double = 0.0
    @Published var isRunning: Bool = false

    private let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "camera.session.queue")
    private var lastInferenceTime: TimeInterval = 0
    private let inferenceInterval: TimeInterval = 0.33 // ~3 fps
    private var requests: [VNRequest] = []

    override init() {
        super.init()
        configureVision()
    }

    func makePreviewLayer() -> AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        return layer
    }

    func start() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                guard granted else { return }
                self.queue.async {
                    self.setupSessionIfNeeded()
                    if !self.session.isRunning { self.session.startRunning() }
                    DispatchQueue.main.async { self.isRunning = true }
                }
            }
        }
    }

    func stop() {
        queue.async {
            if self.session.isRunning { self.session.stopRunning() }
            DispatchQueue.main.async { self.isRunning = false }
        }
    }

    private func setupSessionIfNeeded() {
        guard session.inputs.isEmpty else { return }
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: queue)

        guard session.canAddOutput(output) else {
            session.commitConfiguration()
            return
        }
        session.addOutput(output)
        if let connection = output.connection(with: .video), connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        session.commitConfiguration()
    }

    private func configureVision() {
        let classify = VNClassifyImageRequest()
        // Không dùng imageCropAndScaleOption để tương thích SDK hiện tại
        self.requests = [classify]
    }

    private func handle(results: [VNObservation]) {
        guard let classifications = results as? [VNClassificationObservation],
              let top = classifications.first else { return }

        let english = top.identifier.lowercased()
        let confidence = Double(top.confidence)
        let vietnamese = Self.vietnamese(for: english)

        DispatchQueue.main.async {
            self.currentLabel = vietnamese
            self.currentConfidence = confidence
        }
    }

    private static func vietnamese(for englishLabel: String) -> String {
        let mapping: [String: String] = [
            "chair": "cái ghế",
            "sofa": "ghế sofa",
            "couch": "ghế sofa",
            "table": "cái bàn",
            "desk": "cái bàn làm việc",
            "bottle": "cái chai",
            "cup": "cái cốc",
            "laptop": "máy tính xách tay",
            "keyboard": "bàn phím",
            "mouse": "chuột máy tính",
            "book": "quyển sách",
            "phone": "điện thoại",
            "television": "tivi",
            "tv": "tivi",
            "refrigerator": "tủ lạnh",
            "backpack": "ba lô",
            "shoe": "giày",
            "bicycle": "xe đạp",
            "car": "xe hơi"
        ]
        return mapping[englishLabel] ?? englishLabel
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let now = CACurrentMediaTime()
        if now - lastInferenceTime < inferenceInterval { return }
        lastInferenceTime = now

        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        // iPhone cầm dọc, camera sau: .right
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer, orientation: .right, options: [:])
        do {
            try handler.perform(self.requests)
            if let req = self.requests.first as? VNClassifyImageRequest, let results = req.results {
                self.handle(results: results)
            }
        } catch {
            // Bỏ qua lỗi lẻ tẻ để tránh spam log
        }
    }
}
