//
//  Flashcard.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

struct Flashcard: Identifiable, Codable, Equatable {
    let id: UUID
    let term: String
    let meaning: String
    let ipa: String?
    let example: String?
    let createdAt: Date

    init(term: String, meaning: String, ipa: String? = nil, example: String? = nil) {
        self.id = UUID()
        self.term = term
        self.meaning = meaning
        self.ipa = ipa
        self.example = example
        self.createdAt = Date()
    }
}
