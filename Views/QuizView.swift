//
//  QuizView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct QuizQuestion {
    let prompt: String
    let correct: String
    let options: [String]
}

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: VocabStore

    @State private var questions: [QuizQuestion] = []
    @State private var index: Int = 0
    @State private var selected: String? = nil
    @State private var score: Int = 0
    @State private var finished: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if finished {
                    VStack(spacing: 16) {
                        Text("Hoàn thành!").font(.title2.bold())
                        Text("Điểm: \(score)/\(questions.count)")
                        Button("Làm lại") { startQuiz() }
                            .buttonStyle(.borderedProminent)
                    }
                } else if questions.indices.contains(index) {
                    let q = questions[index]
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Câu \(index + 1)/\(questions.count)").font(.subheadline).foregroundColor(.secondary)
                        Text(q.prompt).font(.title3.bold())
                        ForEach(q.options, id: \.self) { opt in
                            Button { selected = opt } label: {
                                HStack { Text(opt); Spacer(); if selected == opt { Image(systemName: "checkmark.circle.fill").foregroundColor(.blue) } }
                            }
                            .buttonStyle(.bordered)
                        }
                        Button("Tiếp tục") {
                            if let s = selected, s == q.correct { score += 1 }
                            selected = nil
                            if index + 1 >= questions.count { finished = true } else { index += 1 }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selected == nil)
                        .padding(.top, 8)
                        Spacer()
                    }
                    .padding()
                } else {
                    ProgressView().onAppear { startQuiz() }
                }
            }
            .navigationTitle("Quiz")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Đóng") { dismiss() } }
            }
        }
    }

    private func startQuiz() {
        let pool = store.words
        guard pool.count >= 4 else {
            self.questions = pool.map { w in
                QuizQuestion(prompt: "Nghĩa của '\(w.term)' là gì?", correct: w.meaning, options: [w.meaning])
            }
            self.index = 0
            self.score = 0
            self.finished = pool.isEmpty
            return
        }
        var qs: [QuizQuestion] = []
        let shuffled = pool.shuffled()
        for w in shuffled.prefix(10) {
            let distractors = pool.filter { $0.id != w.id }.shuffled().prefix(3).map { $0.meaning }
            let options = ([w.meaning] + distractors).shuffled()
            qs.append(QuizQuestion(prompt: "Nghĩa của '\(w.term)' là gì?", correct: w.meaning, options: options))
        }
        self.questions = qs
        self.index = 0
        self.score = 0
        self.finished = false
    }
}
