//
//  AddWordView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: VocabStore

    @State private var term: String = ""
    @State private var meaning: String = ""
    @State private var example: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Từ vựng") {
                    TextField("Từ (EN)", text: $term)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Nghĩa (VI)", text: $meaning)
                    TextField("Ví dụ (tuỳ chọn)", text: $example)
                }
            }
            .navigationTitle("Thêm từ")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lưu") {
                        let word = Word(
                            term: term.trimmingCharacters(in: .whitespacesAndNewlines),
                            meaning: meaning.trimmingCharacters(in: .whitespacesAndNewlines),
                            example: example.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : example
                        )
                        store.add(word)
                        dismiss()
                    }
                    .disabled(term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                              meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
