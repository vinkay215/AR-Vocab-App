//
//  ShoppingScanView.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI

struct ShoppingScanView: View {
    @State private var text = ""
    @State private var translation = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextEditor(text: $text)
                    .frame(minHeight: 160)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.25)))
                    .padding(.bottom, 4)

                Button {
                    translation = translateToVietnamese(text)
                } label: {
                    Label("Dịch sang tiếng Việt", systemImage: "character.book.closed")
                }
                .buttonStyle(.borderedProminent)

                if !translation.isEmpty {
                    Text(translation)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .navigationTitle("Mua sắm thông minh")
        }
    }

    private func translateToVietnamese(_ s: String) -> String {
        return s.isEmpty ? "" : "Bản dịch (minh hoạ): \(s)"
    }
}
