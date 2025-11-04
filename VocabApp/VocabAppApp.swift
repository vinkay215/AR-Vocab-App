//
//  VocabAppApp.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//



import SwiftUI

@main
struct VocabAppApp: App {
    @StateObject private var store = VocabStore()
    var body: some Scene {
        WindowGroup {
            RootContainer()
                .environmentObject(store)
        }
    }
}
