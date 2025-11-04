//
//  VocabStore.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import Foundation
import SwiftUI

final class VocabStore: ObservableObject {
    @Published var words: [Word] = []
    @Published var searchText: String = ""
    
    var filteredWords: [Word] {
        guard !searchText.isEmpty else { return words }
        
        let query = searchText.lowercased()
        return words.filter { word in
            word.term.lowercased().contains(query) ||
            word.meaning.lowercased().contains(query)
        }
    }
    
    init() {
        loadWords()
    }
    
    func add(_ word: Word) {
        words.append(word)
        saveWords()
    }
    
    func toggleLearned(_ word: Word) {
        if let index = words.firstIndex(where: { $0.id == word.id }) {
            words[index].learned.toggle()
            saveWords()
        }
    }
    
    func delete(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
        saveWords()
    }
    
    private func saveWords() {
        if let encoded = try? JSONEncoder().encode(words) {
            UserDefaults.standard.set(encoded, forKey: "SavedWords")
        }
    }
    
    private func loadWords() {
        if let data = UserDefaults.standard.data(forKey: "SavedWords"),
           let decoded = try? JSONDecoder().decode([Word].self, from: data) {
            words = decoded
        }
    }
}

