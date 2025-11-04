//
//  QuizItem.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

struct QuizItem: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
}
