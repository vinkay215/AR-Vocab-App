//
//  Achievement.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    var unlocked: Bool
    var unlockedAt: Date?
}
