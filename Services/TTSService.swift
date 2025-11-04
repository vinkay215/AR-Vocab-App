//
//  TTSService.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import AVFoundation

final class TTSService {
    static let shared = TTSService()
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String, lang: String = "en-US", rate: Float = 0.48) {
        guard !text.isEmpty else { return }
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: lang)
        u.rate = rate
        synth.speak(u)
    }
}
