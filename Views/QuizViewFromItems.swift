//
//  QuizViewFromItems.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI

struct QuizViewFromItems: View {
    let items: [QuizItem]
    @State private var idx = 0
    @State private var score = 0

    var body: some View {
        VStack(spacing: 16) {
            if idx < items.count {
                let q = items[idx]
                Text(q.question).font(.headline)
                ForEach(q.options.indices, id: \.self) { i in
                    Button {
                        if i == q.correctIndex { score += 1 }
                        idx += 1
                    } label: {
                        Text(q.options[i])
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else {
                Text("Hoàn thành! Điểm: \(score)/\(items.count)")
                    .font(.title3.weight(.semibold))
            }
        }
        .padding()
        .navigationTitle("Quiz")
    }
}
