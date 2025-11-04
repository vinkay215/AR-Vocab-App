//
//  MissionsStore.swift
//  VocabApp
//
//  Created by Vinkay on 19/09/2025.
//

import Foundation

final class MissionsStore: ObservableObject {
    @Published var mission = DailyMission(title: "Quét 5 đồ vật quanh nhà", target: 5, progress: 0)
    func tickScan() { mission.progress = min(mission.progress + 1, mission.target) }
}
