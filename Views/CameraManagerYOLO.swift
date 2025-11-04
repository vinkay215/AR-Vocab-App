//
//  CameraManagerYOLO.swift
//  VocabApp
//
//  YOLO Camera Manager based on VinkayVocabLexiApp implementation
//

import SwiftUI
import Vision
import CoreML
import AVFoundation

// MARK: - Observation Model
struct YOLOObservation: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect
}

// MARK: - Camera Manager (AVCaptureSession + YOLOv3)
class CameraManagerYOLO: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectedObjects: [YOLOObservation] = []
    @Published var centerObject: YOLOObservation? = nil
    @Published var isSessionRunning = false
    
    // Published properties matching ARCameraViewModel interface
    @Published var englishLabel: String = ""
    @Published var vietnameseLabel: String = ""
    @Published var ipaLabel: String = ""
    @Published var confidence: Double = 0.0
    
    let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let visionQueue = DispatchQueue(label: "vision.processing.queue", qos: .userInitiated)
    private var visionModel: VNCoreMLModel?
    private var videoDevice: AVCaptureDevice?
    private var isProcessing = false
    private var lastProcessTime: CFTimeInterval = 0
    private let processingInterval: CFTimeInterval = 0.033 // ~30 FPS
    
    // Smoothing variables
    private var previousObservations: [String: YOLOObservation] = [:]
    private let smoothingFactor: CGFloat = 0.2
    private var smoothedCenterObject: YOLOObservation? = nil
    
    // Label stabilization
    private var lastChosen: LexiconEntry?
    private var lastChosenConf: Double = 0
    private var stableCount: Int = 0
    private let stableNeeded: Int = 2
    
    override init() {
        super.init()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        setupModel()
        setupCamera()
    }
    
    private func setupCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .high
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
                print("Error: Could not get video device")
                self.captureSession.commitConfiguration()
                return
            }
            
            self.videoDevice = videoDevice
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                
                if self.captureSession.canAddInput(videoInput) {
                    self.captureSession.addInput(videoInput)
                } else {
                    print("Error: Could not add video input")
                    self.captureSession.commitConfiguration()
                    return
                }
            } catch {
                print("Error creating video input: \(error.localizedDescription)")
                self.captureSession.commitConfiguration()
                return
            }
            
            // Setup video output
            if self.captureSession.canAddOutput(self.videoOutput) {
                self.captureSession.addOutput(self.videoOutput)
                self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video.output.queue"))
                self.videoOutput.videoSettings = [
                    kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
                ]
                
                if let connection = self.videoOutput.connection(with: .video) {
                    if connection.isVideoOrientationSupported {
                        connection.videoOrientation = self.getCurrentVideoOrientation()
                    }
                    if connection.isVideoMirroringSupported {
                        connection.isVideoMirrored = false
                    }
                }
            } else {
                print("Error: Could not add video output")
                self.captureSession.commitConfiguration()
                return
            }
            
            self.captureSession.commitConfiguration()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    private func getCurrentVideoOrientation() -> AVCaptureVideoOrientation {
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                switch windowScene.interfaceOrientation {
                case .portrait:
                    return .portrait
                case .landscapeLeft:
                    return .landscapeLeft
                case .landscapeRight:
                    return .landscapeRight
                default:
                    return .portrait
                }
            }
            return .portrait
        }
    }
    
    @objc private func orientationChanged() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            
            if let connection = self.videoOutput.connection(with: .video),
               connection.isVideoOrientationSupported {
                connection.videoOrientation = self.getCurrentVideoOrientation()
            }
        }
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupModel() {
        sessionQueue.async { [weak self] in
            do {
                let config = MLModelConfiguration()
                config.computeUnits = .cpuAndNeuralEngine
                
                let model = try YOLOv3(configuration: config)
                self?.visionModel = try VNCoreMLModel(for: model.model)
                print("✅ [YOLO MODEL] Loaded successfully")
            } catch {
                print("❌ [YOLO MODEL] Error: \(error.localizedDescription)")
            }
        }
    }
    
    func start() {
        startSession()
    }
    
    func stop() {
        stopSession()
    }
    
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
                print("✅ [YOLO CAMERA] Started")
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
                print("🛑 [YOLO CAMERA] Stopped")
            }
        }
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastProcessTime >= processingInterval,
              !isProcessing,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = visionModel else {
            return
        }
        
        lastProcessTime = currentTime
        isProcessing = true
        
        visionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Vision request error: \(error.localizedDescription)")
                    self.isProcessing = false
                    return
                }
                
                guard let results = request.results as? [VNRecognizedObjectObservation] else {
                    self.isProcessing = false
                    return
                }
                
                let rawObservations = results.compactMap { result -> YOLOObservation? in
                    guard let label = result.labels.first?.identifier,
                          result.confidence > 0.3 else { return nil }
                    
                    return YOLOObservation(
                        label: label,
                        confidence: Float(result.confidence),
                        boundingBox: result.boundingBox
                    )
                }
                
                let smoothedObservations = self.smoothObservations(rawObservations)
                let centerObject = self.findCenterObject(smoothedObservations)
                let ultraSmoothCenter = self.smoothCenterObject(centerObject)
                
                // Update labels with lexicon lookup
                self.updateLabels(from: ultraSmoothCenter)
                
                DispatchQueue.main.async {
                    self.detectedObjects = smoothedObservations
                    self.centerObject = ultraSmoothCenter
                    self.isProcessing = false
                }
            }
            
            request.imageCropAndScaleOption = .scaleFill
            let options: [VNImageOption: Any] = [:]
            let currentOrientation = self.getCurrentImageOrientation()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: currentOrientation, options: options)
            do {
                try handler.perform([request])
            } catch {
                print("Error performing Vision request: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
            }
        }
    }
    
    private func updateLabels(from observation: YOLOObservation?) {
        guard let obs = observation else {
            DispatchQueue.main.async {
                self.englishLabel = ""
                self.vietnameseLabel = ""
                self.ipaLabel = ""
                self.confidence = 0.0
            }
            return
        }
        
        let raw = obs.label.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let pickedConf = Double(obs.confidence)
        
        // Lookup in lexicon
        guard let chosen = LexiconManager.lookup(rawLabel: raw) else {
            // Not in lexicon, use raw label
            updateUI(en: raw, vi: raw, ipa: "", confidence: pickedConf)
            return
        }
        
        // Stabilize label
        if let last = lastChosen, last.en == chosen.en {
            stableCount += 1
            lastChosenConf = max(lastChosenConf, pickedConf)
        } else {
            lastChosen = chosen
            lastChosenConf = pickedConf
            stableCount = 1
        }
        
        if stableCount >= stableNeeded || englishLabel.isEmpty {
            updateUI(en: chosen.en, vi: chosen.vi, ipa: chosen.ipa, confidence: lastChosenConf)
        }
    }
    
    private func updateUI(en: String, vi: String, ipa: String, confidence: Double) {
        DispatchQueue.main.async {
            self.englishLabel = en
            self.vietnameseLabel = vi
            self.ipaLabel = ipa
            self.confidence = confidence
        }
    }
    
    // MARK: - Smoothing
    private func smoothObservations(_ newObservations: [YOLOObservation]) -> [YOLOObservation] {
        var smoothed: [YOLOObservation] = []
        var matchedKeys: Set<String> = []
        
        for observation in newObservations {
            var bestMatch: (key: String, observation: YOLOObservation, iou: CGFloat)? = nil
            
            for (key, previous) in previousObservations {
                guard previous.label == observation.label else { continue }
                
                let iou = calculateIoU(box1: previous.boundingBox, box2: observation.boundingBox)
                
                if iou > 0.1 {
                    if bestMatch == nil || iou > bestMatch!.iou {
                        bestMatch = (key, previous, iou)
                    }
                }
            }
            
            if let match = bestMatch {
                let smoothedBox = interpolateRects(
                    from: match.observation.boundingBox,
                    to: observation.boundingBox,
                    factor: smoothingFactor
                )
                
                let smoothedConfidence = match.observation.confidence * (1 - Float(smoothingFactor)) + observation.confidence * Float(smoothingFactor)
                
                let smoothedObs = YOLOObservation(
                    label: observation.label,
                    confidence: smoothedConfidence,
                    boundingBox: smoothedBox
                )
                
                smoothed.append(smoothedObs)
                previousObservations[match.key] = smoothedObs
                matchedKeys.insert(match.key)
            } else {
                smoothed.append(observation)
                let newKey = UUID().uuidString
                previousObservations[newKey] = observation
                matchedKeys.insert(newKey)
            }
        }
        
        previousObservations = previousObservations.filter { matchedKeys.contains($0.key) }
        
        return smoothed
    }
    
    private func calculateIoU(box1: CGRect, box2: CGRect) -> CGFloat {
        let intersection = box1.intersection(box2)
        let intersectionArea = intersection.width * intersection.height
        let unionArea = box1.width * box1.height + box2.width * box2.height - intersectionArea
        
        guard unionArea > 0 else { return 0 }
        return intersectionArea / unionArea
    }
    
    private func interpolateRects(from: CGRect, to: CGRect, factor: CGFloat) -> CGRect {
        let origin = CGPoint(
            x: from.origin.x + (to.origin.x - from.origin.x) * factor,
            y: from.origin.y + (to.origin.y - from.origin.y) * factor
        )
        let size = CGSize(
            width: from.width + (to.width - from.width) * factor,
            height: from.height + (to.height - from.height) * factor
        )
        return CGRect(origin: origin, size: size)
    }
    
    private func smoothCenterObject(_ new: YOLOObservation?) -> YOLOObservation? {
        guard let new = new else {
            smoothedCenterObject = nil
            return nil
        }
        
        if let old = smoothedCenterObject, old.label != new.label {
            smoothedCenterObject = new
            return new
        }
        
        guard let old = smoothedCenterObject else {
            smoothedCenterObject = new
            return new
        }
        
        let extraSmoothFactor: CGFloat = 0.25
        let smoothedBox = interpolateRects(
            from: old.boundingBox,
            to: new.boundingBox,
            factor: extraSmoothFactor
        )
        
        let smoothedConfidence = old.confidence * (1 - Float(extraSmoothFactor)) + new.confidence * Float(extraSmoothFactor)
        
        let smoothed = YOLOObservation(
            label: new.label,
            confidence: smoothedConfidence,
            boundingBox: smoothedBox
        )
        
        smoothedCenterObject = smoothed
        return smoothed
    }
    
    private func getCurrentImageOrientation() -> CGImagePropertyOrientation {
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .portrait:
            return .up
        case .portraitUpsideDown:
            return .down
        case .landscapeLeft:
            return .left
        case .landscapeRight:
            return .right
        default:
            return .up
        }
    }
    
    private func findCenterObject(_ observations: [YOLOObservation]) -> YOLOObservation? {
        guard !observations.isEmpty else { return nil }
        
        let scopeCenter = CGPoint(x: 0.5, y: 0.5)
        var bestObservation: YOLOObservation? = nil
        var bestScore: CGFloat = -1
        
        for observation in observations {
            let box = observation.boundingBox
            let boxCenterY = 1.0 - box.midY
            
            let boxCenter = CGPoint(
                x: box.midX,
                y: boxCenterY
            )
            
            let distanceToCenter = sqrt(
                pow(boxCenter.x - scopeCenter.x, 2) +
                pow(boxCenter.y - scopeCenter.y, 2)
            )
            
            let scopeInVisionCoords = CGPoint(x: scopeCenter.x, y: 1.0 - scopeCenter.y)
            let scopeInBox = box.contains(scopeInVisionCoords)
            
            guard distanceToCenter < 0.15 || scopeInBox else {
                continue
            }
            
            var score: CGFloat = 0
            
            if scopeInBox {
                score = 10000 + CGFloat(observation.confidence) * 1000 + (box.width * box.height) * 100
            } else {
                let inverseDistance = 1.0 / (distanceToCenter + 0.001)
                let boxSize = box.width * box.height
                let distancePenalty = pow(1.0 - distanceToCenter / 0.15, 2)
                score = inverseDistance * distancePenalty * 100 * CGFloat(observation.confidence) * boxSize
            }
            
            if score > bestScore {
                bestScore = score
                bestObservation = observation
            }
        }
        
        return bestObservation
    }
}

// MARK: - Camera Preview ViewController
class YOLOCameraViewController: UIViewController {
    var cameraManager: CameraManagerYOLO?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPreviewLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreviewLayerFrame()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updatePreviewLayerFrame()
        })
    }
    
    private func setupPreviewLayer() {
        guard let cameraManager = cameraManager else { return }
        let layer = AVCaptureVideoPreviewLayer(session: cameraManager.captureSession)
        layer.videoGravity = .resizeAspectFill
        
        if let connection = layer.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = getCurrentVideoOrientation()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        
        view.layer.insertSublayer(layer, at: 0)
        previewLayer = layer
        updatePreviewLayerFrame()
    }
    
    func updatePreviewLayerFrame() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.previewLayer?.frame = self.view.bounds
            self.updateOrientation()
        }
    }
    
    private func getCurrentVideoOrientation() -> AVCaptureVideoOrientation {
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portrait
        }
    }
    
    private func updateOrientation() {
        if let connection = previewLayer?.connection, connection.isVideoOrientationSupported {
            connection.videoOrientation = getCurrentVideoOrientation()
        }
    }
    
    @objc private func orientationDidChange() {
        updateOrientation()
        updatePreviewLayerFrame()
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SwiftUI Camera Preview
struct YOLOCameraPreview: UIViewControllerRepresentable {
    let cameraManager: CameraManagerYOLO
    
    func makeUIViewController(context: Context) -> YOLOCameraViewController {
        let viewController = YOLOCameraViewController()
        viewController.cameraManager = cameraManager
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: YOLOCameraViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.updatePreviewLayerFrame()
        }
    }
}

// MARK: - Bounding Box View
struct YOLOBoundingBoxView: View {
    let observation: YOLOObservation
    let geometry: GeometryProxy
    
    private var normalizedBox: CGRect {
        observation.boundingBox
    }
    
    private var viewWidth: CGFloat {
        geometry.size.width
    }
    
    private var viewHeight: CGFloat {
        geometry.size.height
    }
    
    private var x: CGFloat {
        normalizedBox.origin.x * viewWidth
    }
    
    private var y: CGFloat {
        (1.0 - normalizedBox.origin.y - normalizedBox.height) * viewHeight
    }
    
    private var width: CGFloat {
        normalizedBox.width * viewWidth
    }
    
    private var height: CGFloat {
        normalizedBox.height * viewHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(observation.label.capitalized)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.red)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red, lineWidth: 2.5)
                .frame(width: width, height: height)
        }
        .position(x: x + width/2, y: y + height/2)
        .animation(.easeInOut(duration: 0.2), value: observation.boundingBox)
    }
}

