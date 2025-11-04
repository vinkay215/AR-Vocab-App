//
//  ProfileView.swift
//  VocabApp
//
//  Created by Vinkay on 18/09/2025.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ProfileView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var initialOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
            ScrollView {
                    VStack(spacing: 0) {
                        // Khoảng trống 10pt ngoài thẻ header
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
                        
                        // Header với avatar và điểm số - full width
                    headerSection
                    
                        // Nút Chỉnh sửa và Chia sẻ
                    actionButtons
                    
                        VStack(spacing: 24) {
                            // Achievements Section
                            achievementsSection
                            
                            // Progress Section
                            progressSection
                            
                            // Streak Section
                            streakSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100) // Thêm padding bottom để tránh bị che bởi tabbar
                    }
                }
                .scrollIndicators(.hidden) // Ẩn thanh scroll
                .background(Color(.systemGroupedBackground))
                
                // Status bar overlay - CHỈ hiện khi scroll XUỐNG (initialOffset - scrollOffset > 0)
                GeometryReader { geometry in
                    let statusBarHeight = geometry.safeAreaInsets.top
                    let scrolled = initialOffset - scrollOffset
                    let shouldShow = scrolled > 10  // Chỉ hiện khi scroll xuống > 10pt
                    
                    Color.white
                        .frame(height: statusBarHeight)
                        .ignoresSafeArea()
                        .opacity(shouldShow ? 1 : 0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .allowsHitTesting(false)
                .animation(.easeInOut(duration: 0.2), value: initialOffset - scrollOffset > 10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Hàng trên: Avatar + User Info
            HStack(alignment: .center, spacing: 16) {
                // 1. Avatar (góc trên bên trái)
                Circle()
                    .fill(Color.clear)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image("avt_default")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    )
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "4A90E2"), lineWidth: 2)
                    )
                
                // 2. User Info (bên phải avatar)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nguyễn Quốc Vinh")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "1A1A1A"))
                    
                    Text("Tham gia vào tháng 9 năm 2025")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "8C8C8C"))
                }
                
                Spacer()
            }
            
            // Hàng dưới: 2 nút hành động
        HStack(spacing: 12) {
                // Nút trái: Chỉnh sửa
            Button {
                    // Action: Chỉnh sửa
            } label: {
                    Text("Chỉnh sửa")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "4CAF50"))
                    .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "EAFBEA"))
                        .cornerRadius(25)
                }
                
                // Nút phải: Chia sẻ
            Button {
                // Action: Chia sẻ
            } label: {
                Text("Chia sẻ")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "FFFFFF"))
                    .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "4CAF50"))
                        .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20) // Padding top bình thường cho header
        .padding(.bottom, 20)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20) // Thêm padding để không dính mép
    }
    
    private var actionButtons: some View {
        EmptyView()
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 12) {
                achievementCard(
                    title: "Giao tiếp cơ bản",
                    description: "Hoàn thành khoá học để nhận",
                    buttonText: "Nhận ngay",
                    imageName: "AVM_TuVung"
                )
                
                achievementCard(
                    title: "2000 từ vựng",
                    description: "Hoàn thành khoá học để nhận",
                    buttonText: "Nhận ngay",
                    imageName: "AVM_2000"
                )
                
                achievementCard(
                    title: "Hacking 1500 Vocab",
                    description: "Hoàn thành khoá học để nhận",
                    buttonText: "Nhận ngay",
                    imageName: "AVM_Hacking"
                )
            }
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tiến trình")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 16) {
                // Radar Chart
                RadarChartView()
                    .frame(height: 280)
                
                // Summary cards với màu theo thiết kế
                HStack(spacing: 12) {
                    summaryCard(
                        iconImage: "ic_grand",
                        number: "4",
                        label: "Khóa học",
                        backgroundColor: Color(hex: "EAFFF8")
                    )
                    summaryCard(
                        iconImage: "ic_book",
                        number: "10",
                        label: "Bài học",
                        backgroundColor: Color(hex: "ECF6FF")
                    )
                    summaryCard(
                        iconImage: nil,
                        number: "7.8",
                        label: "Điểm",
                        backgroundColor: Color(hex: "FFEDEF"),
                        isScore: true
                    )
                }
            }
            .padding(16)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func summaryCard(
        iconImage: String?,
        number: String,
        label: String,
        backgroundColor: Color,
        isScore: Bool = false
    ) -> some View {
        VStack(spacing: 4) {
            if let iconImage = iconImage {
                // Icon ở trên
                Image(iconImage)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                
                // Số ở dưới icon, size bằng chiều cao icon
                Text(number)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.primary)
            } else {
                // Chỉ hiển thị số (cho card điểm)
                Text(number)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(hex: "FF6B6B"))
                
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var streakSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streak của bạn")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 16) {
                // Streak counter
                HStack {
                    Text("140 Days")
                        .font(.body.weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.yellow.opacity(0.2))
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                // Daily streak indicators
                HStack(spacing: 4) {
                    ForEach(Array(zip(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], [false, false, true, true, true, true, true])), id: \.0) { day, isActive in
                        VStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.title3)
                                .foregroundColor(isActive ? .orange : .gray.opacity(0.3))
                            
                            Text(day)
                                .font(.caption2.weight(.medium))
                                .foregroundColor(isActive ? .orange : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(16)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func achievementCard(
        title: String,
        description: String,
        buttonText: String,
        imageName: String
    ) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button {
                    // Action: Nhận ngay
                } label: {
                    Text(buttonText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "4CAF50"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(hex: "EAFBEA"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "4CAF50"), lineWidth: 1)
                        )
                }
            }
            
            Spacer()
            
            // Achievement Image
            Image(imageName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(12)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Radar Chart View
struct RadarChartView: View {
    let skills = ["Phát âm", "Trôi chảy", "Ngữ điệu", "Đọc", "Nghe"]
    let values: [Double] = [0.3, 0.4, 0.25, 0.5, 0.35]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2.5
            
            ZStack {
                backgroundGrid(center: center, radius: radius)
                axes(center: center, radius: radius)
                dataPolygon(center: center, radius: radius)
                labels(center: center, radius: radius)
            }
        }
    }
    
    private func backgroundGrid(center: CGPoint, radius: CGFloat) -> some View {
        ForEach(0..<5) { level in
            let levelRadius = radius * (Double(level + 1) / 5)
            createGridPath(center: center, radius: levelRadius)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        }
    }
    
    private func axes(center: CGPoint, radius: CGFloat) -> some View {
        Group {
            ForEach(0..<skills.count, id: \.self) { index in
                createAxis(center: center, radius: radius, index: index)
            }
        }
    }
    
    private func createAxis(center: CGPoint, radius: CGFloat, index: Int) -> some View {
        let angle = Double(index) * 2 * .pi / Double(skills.count) - .pi / 2
        let endX = center.x + radius * cos(angle)
        let endY = center.y + radius * sin(angle)
        
        return Path { path in
            path.move(to: center)
            path.addLine(to: CGPoint(x: endX, y: endY))
        }
        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
    }
    
    private func dataPolygon(center: CGPoint, radius: CGFloat) -> some View {
        createDataPath(center: center, radius: radius)
            .fill(Color.green.opacity(0.2))
            .overlay(
                createDataPath(center: center, radius: radius)
                    .stroke(Color.green, lineWidth: 2)
            )
    }
    
    private func labels(center: CGPoint, radius: CGFloat) -> some View {
        Group {
            ForEach(0..<skills.count, id: \.self) { index in
                createLabel(center: center, radius: radius, index: index)
            }
        }
    }
    
    private func createLabel(center: CGPoint, radius: CGFloat, index: Int) -> some View {
        let angle = Double(index) * 2 * .pi / Double(skills.count) - .pi / 2
        let labelRadius = radius + 25
        let x = center.x + labelRadius * cos(angle)
        let y = center.y + labelRadius * sin(angle)
        
        return VStack(spacing: 2) {
            Text(skills[index])
                .font(.caption2.weight(.medium))
                .foregroundStyle(.primary)
            
            Text("--")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .position(x: x, y: y)
    }
    
    private func createGridPath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            for i in 0..<skills.count {
                let angle = Double(i) * 2 * .pi / Double(skills.count) - .pi / 2
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
    
    private func createDataPath(center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            for i in 0..<skills.count {
                let angle = Double(i) * 2 * .pi / Double(skills.count) - .pi / 2
                let valueRadius = radius * values[i]
                let x = center.x + valueRadius * cos(angle)
                let y = center.y + valueRadius * sin(angle)
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
