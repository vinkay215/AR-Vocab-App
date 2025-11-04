//  ContentView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: VocabStore
    @State private var showingAdd = false
    @State private var showingQuiz = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.filteredWords) { word in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.term).font(.headline)
                            Text(word.meaning).font(.subheadline).foregroundStyle(.secondary)
                            if let ex = word.example, !ex.isEmpty {
                                Text(ex).font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Button {
                            store.toggleLearned(word)
                        } label: {
                            Image(systemName: word.learned ? "checkmark.circle.fill" : "circle")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(word.learned ? .green : .gray)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            if let idx = store.words.firstIndex(of: word) {
                                store.delete(at: IndexSet(integer: idx))
                            }
                        } label: { Label("Xoá", systemImage: "trash") }
                    }
                }
            }
            .searchable(text: $store.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Tìm từ hoặc nghĩa")
            .navigationTitle("Vocabulary")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { showingQuiz = true } label: { Label("Quiz", systemImage: "gamecontroller") }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: { Label("Thêm từ", systemImage: "plus") }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink { CameraScreen() } label: { Label("Camera", systemImage: "camera") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddWordView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingQuiz) {
                QuizView()
                    .presentationDetents([.large])
            }
        }
    }
}
