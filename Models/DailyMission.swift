//
//  DailyMission.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

struct DailyMission: Identifiable, Codable {
    let id = UUID()
    let title: String
    let target: Int
    var progress: Int
    var completed: Bool { progress >= target }
}
