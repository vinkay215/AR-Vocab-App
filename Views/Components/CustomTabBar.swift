//
//  CustomTabBar.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

enum AppTab: Hashable { case home, camera, explore, profile }

struct CustomTabBar: View {
    @Binding var selection: AppTab

    var body: some View {
        HStack(spacing: 0) {
            item(active: "ic_home_active", inactive: "ic_home_inactive", tab: .home, isSelected: selection == .home)
            item(active: "ic_camera_active", inactive: "ic_camera_inactive", tab: .camera, isSelected: selection == .camera)
            item(active: "ic_grid_active", inactive: "ic_grid_inactive", tab: .explore, isSelected: selection == .explore)
            item(active: "ic_profile_active", inactive: "ic_profile_inactive", tab: .profile, isSelected: selection == .profile)
        }
        .padding(.horizontal, 8)
        .frame(height: 65)
        .background(
            LiquidGlassBackground()
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 0)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    @ViewBuilder
    private func item(active: String, inactive: String, tab: AppTab, isSelected: Bool) -> some View {
        Button { 
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = tab 
            }
        } label: {
            Image(isSelected ? active : inactive)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .buttonStyle(.plain)
    }
}

// Liquid Glass Background Effect theo Apple documentation
// https://developer.apple.com/documentation/swiftui/applying-liquid-glass-to-custom-views
struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            // Base material với ultraThinMaterial cho hiệu ứng trong suốt liquid glass
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
            
            // Gradient overlay để tạo độ sâu và ánh sáng
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.5), location: 0),
                            .init(color: .white.opacity(0.15), location: 0.5),
                            .init(color: .white.opacity(0.35), location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(
            // Gradient border với màu trắng opacity cao - đặc trưng của liquid glass
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.9), location: 0),
                            .init(color: .white.opacity(0.6), location: 0.5),
                            .init(color: .white.opacity(0.8), location: 1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        // Multiple shadow layers để tạo độ sâu - đặc trưng của liquid glass
        .shadow(color: .black.opacity(0.2), radius: 25, x: 0, y: -8)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}