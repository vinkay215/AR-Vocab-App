//
//  KidsStoryService.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

enum KidsStoryService {
    static func makeStory(with word: String, meaning: String) -> String {
        guard !word.isEmpty else { return "Một ngày nọ, bé khám phá thế giới đồ chơi." }
        return "Hôm nay, bé gặp \(word) (\(meaning)). \(word.capitalized) đã kể một câu chuyện nhỏ giúp bé nhớ từ thật lâu!"
    }
}
