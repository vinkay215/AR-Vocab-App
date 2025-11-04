//
//  OCRService.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Vision
import UIKit

final class OCRService {
    func recognizeText(in image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cg = image.cgImage else { return }
        let req = VNRecognizeTextRequest { req, err in
            if let err = err { completion(.failure(err)); return }
            let text = (req.results as? [VNRecognizedTextObservation])?
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ") ?? ""
            completion(.success(text))
        }
        req.recognitionLevel = .accurate
        req.usesLanguageCorrection = true
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do { try handler.perform([req]) } catch { completion(.failure(error)) }
        }
    }
}   
