//
//  YOLOObjectDetectionService.swift
//  VocabApp
//
//  Created by AI Assistant on 25/10/2025.
//  YOLO11n Object Detection Service
//

import CoreML
import Vision
import UIKit
import CoreVideo

// MARK: - Detected Object Model
struct DetectedObject {
    let className: String
    let confidence: Float
    let boundingBox: CGRect
}

// MARK: - Detection Error
enum ObjectDetectionError: Error {
    case modelNotLoaded
    case invalidImage
    case detectionFailed
}

// MARK: - YOLO Object Detection Service
final class YOLOObjectDetectionService {
    private var model: VNCoreMLModel?
    private var isInitialized = false
    
    init() {
        loadModel()
        print("🟢 [YOLO MODEL] Initializing...")
    }
    
    // MARK: - Model Loading
    private func loadModel() {
        guard let modelURL = Bundle.main.url(forResource: "Vinkay11n", withExtension: "mlpackage") else {
            print("❌ [YOLO MODEL] Không tìm thấy Vinkay11n.mlpackage trong bundle")
            print("❌ [YOLO MODEL] Model path: Vinkay11n.mlpackage")
            return
        }
        
        print("🟢 [YOLO MODEL] Found model at: \(modelURL.path)")
        
        do {
            let mlModel = try MLModel(contentsOf: modelURL)
            model = try VNCoreMLModel(for: mlModel)
            isInitialized = true
            print("✅ [YOLO MODEL] Successfully loaded YOLO11n model")
            print("✅ [YOLO MODEL] Model: Vinkay11n (YOLO11n by Ultralytics)")
            print("✅ [YOLO MODEL] Classes: 80+ (COCO dataset)")
            print("✅ [YOLO MODEL] Type: Object Detection with Bounding Boxes")
            print("✅ [YOLO MODEL] Ready for real-time detection")
        } catch {
            print("❌ [YOLO MODEL] Failed to load: \(error.localizedDescription)")
            print("❌ [YOLO MODEL] Error: \(error)")
        }
    }
    
    // MARK: - Object Detection from CVPixelBuffer (for real-time camera)
    func detectObjects(in pixelBuffer: CVPixelBuffer, orientation: CGImagePropertyOrientation = .right, completion: @escaping (Result<[DetectedObject], Error>) -> Void) {
        guard let model = model, isInitialized else {
            completion(.failure(ObjectDetectionError.modelNotLoaded))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.processResults(request.results, completion: completion)
        }
        
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Object Detection from UIImage
    func detectObjects(in image: UIImage, completion: @escaping (Result<[DetectedObject], Error>) -> Void) {
        guard let model = model, isInitialized else {
            completion(.failure(ObjectDetectionError.modelNotLoaded))
            return
        }
        
        guard let cgImage = image.cgImage else {
            completion(.failure(ObjectDetectionError.invalidImage))
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.processResults(request.results, completion: completion)
        }
        
        request.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Process Detection Results
    private func processResults(_ results: [Any]?, completion: @escaping (Result<[DetectedObject], Error>) -> Void) {
        guard let results = results as? [VNRecognizedObjectObservation] else {
            completion(.success([]))
            return
        }
        
        let detectedObjects = results.compactMap { observation -> DetectedObject? in
            guard let topLabel = observation.labels.first else { return nil }
            
            // Filter by confidence threshold
            guard topLabel.confidence > 0.3 else { return nil }
            
            return DetectedObject(
                className: topLabel.identifier,
                confidence: topLabel.confidence,
                boundingBox: observation.boundingBox
            )
        }
        
        // Sort by confidence
        let sortedObjects = detectedObjects.sorted { $0.confidence > $1.confidence }
        
        completion(.success(sortedObjects))
    }
    
    // MARK: - Get Best Detection
    func getBestDetection(from objects: [DetectedObject]) -> DetectedObject? {
        return objects.first
    }
    
    // MARK: - Filter Vocabulary Objects
    func filterVocabularyObjects(_ objects: [DetectedObject]) -> [DetectedObject] {
        let vocabularyKeywords = [
            "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat",
            "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog",
            "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella",
            "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite",
            "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle",
            "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich",
            "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch",
            "potted plant", "bed", "dining table", "toilet", "tv", "laptop", "mouse", "remote",
            "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator", "book",
            "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
        ]
        
        return objects.filter { object in
            vocabularyKeywords.contains { keyword in
                object.className.lowercased().contains(keyword)
            }
        }
    }
}

