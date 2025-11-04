//
//  QuizGenerator.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

enum QuizGenerator {
    static func generate(from text: String, limit: Int = 6) -> [QuizItem] {
        let words = Array(Set(text.split { !$0.isLetter }.map { String($0).lowercased() }))
        let pool = words.filter { $0.count >= 4 }
        let keys = pool.shuffled().prefix(limit)
        return keys.map { w in
            let correct = w
            let distractors = pool.shuffled().filter { $0 != w }.prefix(3)
            let options = ([correct] + distractors).shuffled()
            let idx = options.firstIndex(of: correct) ?? 0
            return QuizItem(question: "Nghĩa của từ: \(correct)", options: options, correctIndex: idx)
        }
    }
}
