//
//  CameraOverlayCard.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

struct CameraOverlayCard: View {
    let english: String
    let ipa: String
    let vietnamese: String
    let confidence: Double
    let onAdd: () -> Void
    let canAdd: Bool

    private let englishColor = Color(hex: "0065BD")
    private let vietnameseColor = Color(hex: "BD0000")
    private let addBg = Color(hex: "C7FFFE").opacity(0.58)
    private let accBg = Color(hex: "FFDCB4").opacity(0.58)
    private let accText = Color(hex: "F86060")

    private let headerFont = Font.system(size: 22, weight: .heavy)
    private let wordFont   = Font.system(size: 20, weight: .semibold)
    private let pillHeight: CGFloat = 28
    private let dividerWidth: CGFloat = 2

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("English")
                        .font(headerFont)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [englishColor, englishColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    VStack(alignment: .leading, spacing: 6) {
                        Text(english.isEmpty ? "—" : english.capitalized)
                            .font(wordFont)
                            .foregroundStyle(.primary)
                            .id("english-\(english)")
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .move(edge: .top)),
                                removal: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .move(edge: .bottom))
                            ))
                        if !ipa.isEmpty {
                            Text(ipa)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .id("ipa-\(ipa)")
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                                    removal: .opacity.combined(with: .move(edge: .top))
                                ))
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: english)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: ipa)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Liquid glass divider
                RoundedRectangle(cornerRadius: dividerWidth / 2)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.secondary.opacity(0.4),
                                Color.white.opacity(0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: dividerWidth)
                    .frame(maxHeight: 66)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Vietnamese")
                        .font(headerFont)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [vietnameseColor, vietnameseColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    VStack(alignment: .leading, spacing: 6) {
                        Text(vietnamese.isEmpty ? "—" : vietnamese)
                            .font(wordFont)
                            .foregroundStyle(.primary)
                            .id("vietnamese-\(vietnamese)")
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .move(edge: .top)),
                                removal: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .move(edge: .bottom))
                            ))
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vietnamese)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                // Add button with liquid glass
                Button(action: onAdd) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .bold))
                        Text("Thêm")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "0065BD"),
                                Color(hex: "0065BD").opacity(0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: pillHeight)
                    .padding(.horizontal, 12)
                    .background(
                        LiquidGlassPillBackground(
                            baseColor: addBg,
                            intensity: canAdd ? 1.0 : 0.5
                        )
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!canAdd)
                .scaleEffect(canAdd ? 1.0 : 0.95)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: canAdd)

                Spacer()

                // Confidence badge with liquid glass
                Text(String(format: "Độ chính xác %.0f%%", confidence * 100))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [accText, accText.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: pillHeight)
                    .padding(.horizontal, 12)
                    .background(
                        LiquidGlassPillBackground(
                            baseColor: accBg,
                            intensity: 1.0
                        )
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(
            LiquidGlassCardBackground()
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

// MARK: - Liquid Glass Card Background
// Liquid Glass Background Effect cho Card theo Apple documentation
struct LiquidGlassCardBackground: View {
    var body: some View {
        ZStack {
            // Base material với thinMaterial cho hiệu ứng trong suốt liquid glass
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.thinMaterial)
            
            // Gradient overlay để tạo độ sâu và ánh sáng
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.6), location: 0),
                            .init(color: .white.opacity(0.2), location: 0.5),
                            .init(color: .white.opacity(0.4), location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .overlay(
            // Gradient border với màu trắng opacity cao - đặc trưng của liquid glass
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.95), location: 0),
                            .init(color: .white.opacity(0.7), location: 0.5),
                            .init(color: .white.opacity(0.85), location: 1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        // Multiple shadow layers để tạo độ sâu - đặc trưng của liquid glass
        .shadow(color: .black.opacity(0.25), radius: 30, x: 0, y: -8)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: -4)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Liquid Glass Pill Background
// Liquid Glass Background cho các pill buttons và badges
struct LiquidGlassPillBackground: View {
    let baseColor: Color
    let intensity: Double
    
    var body: some View {
        ZStack {
            // Base color với opacity
            Capsule()
                .fill(baseColor.opacity(intensity * 0.7))
            
            // Gradient overlay
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.4 * intensity), location: 0),
                            .init(color: .white.opacity(0.1 * intensity), location: 0.5),
                            .init(color: .white.opacity(0.3 * intensity), location: 1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay(
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.6 * intensity),
                            .white.opacity(0.3 * intensity)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.1 * intensity), radius: 4, x: 0, y: 2)
    }
}
