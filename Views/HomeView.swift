//
//  HomeView.swift
//  VocabApp
//
//  Created by Vinkay on 17/09/2025.
//

import SwiftUI

// Extension để hỗ trợ hex color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: VocabStore
    @State private var scrollOffset: CGFloat = 0
    @State private var initialOffset: CGFloat = 0

    private struct LearningModule: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let flashcardCount: String
        let icon: String
        let iconColor: Color
    }

    private var learningModules: [LearningModule] {
        [
            LearningModule(title: "Ôn Tập Ngữ Pháp", subtitle: "30 flashcard", flashcardCount: "30", icon: "ic_vocabulary", iconColor: .purple),
            LearningModule(title: "Giao tiếp cơ bản", subtitle: "90 flashcard", flashcardCount: "20", icon: "ic_chat", iconColor: .orange),
            LearningModule(title: "2000 từ vựng thông dụng", subtitle: "40 TOPICS", flashcardCount: "20", icon: "ic_az", iconColor: .blue),
            LearningModule(title: "Bẻ khoá 1500 từ vựng mất gốc", subtitle: "Học siêu tốc", flashcardCount: "20", icon: "ic_brain", iconColor: .cyan)
        ]
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Khoảng trống 10pt để track scroll
                    Color.clear
                        .frame(height: 10)
                        .overlay(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        initialOffset = geometry.frame(in: .global).minY
                                    }
                                    .onChange(of: geometry.frame(in: .global).minY) { newValue in
                                        scrollOffset = newValue
                                    }
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 24) {
                        userProfileCard
                        lexiArSection
                        streakSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 0)
                    .tabBarAwareBottomPadding(24)
                }
            }
            .scrollIndicators(.hidden)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.894, green: 0.945, blue: 1.0), // #E4F1FF - xanh nhạt (0%)
                        Color(red: 0.949, green: 0.949, blue: 0.965), // #F2F2F6 - xám nhạt (13%)
                        Color(red: 0.949, green: 0.949, blue: 0.965), // #F2F2F6 - xám nhạt (80%)
                        Color(red: 0.894, green: 0.945, blue: 1.0)  // #E4F1FF - xanh nhạt (100%)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Status bar overlay - CHỈ hiện khi scroll XUỐNG
            GeometryReader { geometry in
                let statusBarHeight = geometry.safeAreaInsets.top
                let scrolled = initialOffset - scrollOffset
                let shouldShow = scrolled > 10
                
                LinearGradient(
                    colors: [
                        Color(red: 0.894, green: 0.945, blue: 1.0), // #E4F1FF - xanh nhạt
                        Color(red: 0.949, green: 0.949, blue: 0.965)  // #F2F2F6 - xám nhạt
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: statusBarHeight)
                .ignoresSafeArea()
                .opacity(shouldShow ? 1 : 0)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .allowsHitTesting(false)
            .animation(.easeInOut(duration: 0.2), value: initialOffset - scrollOffset > 10)
        }
    }
    
    // MARK: - User Profile Card
    private var userProfileCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Avatar
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image("avt_default")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                            )
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .center, spacing: 8) {
                        Text("Nguyễn Quốc Vinh")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.primary)
                        
                        Image("ic_verify")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                    
                    Text("Cùng bạn chinh phục tri thức")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Đã học 500 từ")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 4) {
                    Text("05")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Image("ic_fire")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - LexiAr Section
    private var lexiArSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("LexiAr | Học vui – Hiểu nhanh – Nhớ lâu")
                    .font(.headline.weight(.bold)) // TODO: Thay đổi cỡ chữ ở đây - có thể dùng .title3, .headline, .subheadline
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.137, green: 0.141, blue: 0.129), // #232421 - màu tối
                                Color(red: 0.718, green: 0.816, blue: 0.506)   // #B7D081 - màu sáng
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(learningModules) { module in
                    learningModuleCard(module)
                }
            }
        }
    }

    private func learningModuleCard(_ module: LearningModule) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section với title và flashcard count
            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.20, blue: 0.27))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .frame(height: 40, alignment: .topLeading)
                
                Text("\(module.flashcardCount) flashcard")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.41, green: 0.40, blue: 0.45))
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
            
            // Icon/Image section làm background
            Rectangle()
                .fill(Color.clear)
                .frame(height: 95)
                .background(
                    Image(module.icon)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                )
                .cornerRadius(12)
                .clipped()
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
        .frame(height: 170)
        .background(Color(red: 1, green: 0.99, blue: 0.99))
        .cornerRadius(16)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Streak Section
    private var streakSection: some View {
        VStack(spacing: 16) {
            // Call-to-action text để khuyến khích người dùng bắt đầu streak
            Text("Đã đến lúc bắt đầu Streak!")
                .font(.headline.weight(.bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            // Main streak card với nội dung chính
            VStack(spacing: 16) {
                // Hàng trên: Text hướng dẫn
                HStack {
                    // Text hướng dẫn người dùng về streak
                    Text("Hoàn thành một bài học mỗi ngày để duy trì thành tích của bạn")
                        .font(.subheadline.weight(.semibold)) // TODO: Có thể thay .bold thành .semibold hoặc .heavy để đậm hơn
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                
                // Hàng dưới: 7 ngày trong tuần với trạng thái hoàn thành
                HStack(spacing: 0) {
                    ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                        VStack(spacing: 6) {
                            // Icon lightning bolt - hiển thị trạng thái hoàn thành
                            Image(systemName: "bolt.fill")
                                .font(.title3) // Kích thước lớn hơn subheadline
                                .foregroundColor(day == "Su" || day == "Mo" ? .gray : .orange) // Gray = chưa hoàn thành, Orange = đã hoàn thành
                            
                            // Text ngày tháng
                            Text(day)
                                .font(.subheadline.weight(.bold)) // Lớn hơn caption
                                .foregroundColor(day == "Su" || day == "Mo" ? .gray : .orange) // Cùng màu với icon
                        }
                        .frame(maxWidth: .infinity) // Chia đều không gian cho mỗi ngày
                        .padding(.horizontal, 4) // Padding nhỏ để tạo khoảng cách đều
                    }
                }
                .padding(.top, 8) // Thêm padding trên để tạo khoảng cách với phần trên
            }
            .padding(16) // Padding bên trong card
            .background(
                RoundedRectangle(cornerRadius: 27) // Bo viền 27px như thiết kế
                    .fill(.background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 27)
                    .inset(by: 0.5)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.black.opacity(0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2) // Shadow nhẹ
        }
    }
}
