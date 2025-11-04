//
//  MainTabView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            NavigationStack { ARGuidedLabelViewYOLO() }
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }

            NavigationStack { ContentView() }
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("Từ vựng")
                }

            NavigationStack { QuizView() }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Tôi")
                }
        }
    }
}
