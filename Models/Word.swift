//
//  Word.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import Foundation

struct Word: Identifiable, Codable, Equatable {
    let id: UUID
    var term: String
    var meaning: String
    var example: String?
    var learned: Bool

    init(id: UUID = UUID(), term: String, meaning: String, example: String? = nil, learned: Bool = false) {
        self.id = id
        self.term = term
        self.meaning = meaning
        self.example = example
        self.learned = learned
    }
}
