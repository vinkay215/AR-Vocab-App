//
//  OCRFlashcardView.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import SwiftUI

struct OCRFlashcardView: View {
    @State private var recognized = ""
    @State private var quiz: [QuizItem] = []
    @State private var showingPicker = false
    @State private var picked: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                ScrollView {
                    Text(recognized.isEmpty ? "Chụp/Chọn ảnh trang sách để nhận dạng chữ" : recognized)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if !quiz.isEmpty {
                    NavigationLink("Làm Quiz (\(quiz.count))") {
                        QuizViewFromItems(items: quiz)
                    }
                    .buttonStyle(.borderedProminent)
                }

                HStack {
                    Button {
                        showingPicker = true
                    } label: {
                        Label("Chọn ảnh", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        guard let img = picked else { return }
                        OCRService().recognizeText(in: img) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let text):
                                    recognized = text
                                    quiz = QuizGenerator.generate(from: text)
                                case .failure:
                                    recognized = "OCR thất bại. Thử lại ảnh rõ hơn."
                                }
                            }
                        }
                    } label: {
                        Label("Nhận dạng", systemImage: "text.viewfinder")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(picked == nil)
                }
            }
            .padding()
            .tabBarAwareBottomPadding(24)
            .navigationTitle("Quét sách → Thẻ học")
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker(image: $picked)
        }
    }
}
