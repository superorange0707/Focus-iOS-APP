import SwiftUI
import UIKit

// MARK: - Share Card Models
struct SharePlatform: Hashable {
    let name: String
    let percent: Double
}

struct ShareCardData: Hashable {
    let displayName: String
    let periodLabel: String
    let todaySavedMin: Int
    let totalSavedMin: Int
    let focusScore: Int
    let efficiencyRate: Double
    let topPlatforms: [SharePlatform]
    let trend: [Int]
    let badges: [ShareBadge]
    let generatedAt: Date
    let appVersion: String
}

struct ShareBadge: Hashable {
    let id: String
    let title: String
    let iconName: String
}

// MARK: - Share Card View
struct ShareCardView: View {
    let data: ShareCardData

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gradientTop, .gradientMiddle, .gradientBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Main card container (glass style like app Stats)
            VStack(alignment: .leading, spacing: 28) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SkipFeed")
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                        Text("Focus Report")
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                        Text(data.displayName)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(data.periodLabel)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // KPI Grid (matches CompactStat style)
                HStack(spacing: 24) {
                    kpiCard(title: "Today Saved", value: "\(data.todaySavedMin)m", icon: "clock.badge.checkmark.fill")
                    kpiCard(title: "Total Saved", value: "\(data.totalSavedMin)m", icon: "clock")
                }

                HStack(spacing: 24) {
                    kpiCard(title: "Focus Score", value: "\(data.focusScore)/100", icon: "target")
                    kpiCard(title: "Efficiency", value: String(format: "%.2f", data.efficiencyRate), icon: "chart.line.uptrend.xyaxis")
                }

                // Platform + Trend section in two columns
                HStack(alignment: .top, spacing: 28) {
                    if !data.topPlatforms.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Top Platforms")
                            HStack(spacing: 20) {
                                SharePieChart(segments: data.topPlatforms)
                                    .frame(width: 240, height: 240)
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(Array(data.topPlatforms.prefix(4).enumerated()), id: \.offset) { _, item in
                                        HStack(spacing: 10) {
                                            Circle()
                                                .fill(sharePlatformColor(for: item.name))
                                                .frame(width: 14, height: 14)
                                            Text("\(item.name) \(Int(item.percent))%")
                                                .font(.headline)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader("Recent Trend")
                        ShareTrendChart(values: data.trend)
                            .frame(height: 220)
                    }
                    .padding(20)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }

                // Badges
                if !data.badges.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        sectionHeader("Unlocked Badges")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(data.badges, id: \.id) { badge in
                                    HStack(spacing: 8) {
                                        Image(systemName: badge.iconName)
                                            .font(.title2)
                                        Text(badge.title)
                                            .font(.subheadline)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.cardBackgroundSelected)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }

                Spacer(minLength: 0)

                // Footer
                HStack {
                    Text("Generated on \(DateFormatter.shortDate.string(from: data.generatedAt)) · v\(data.appVersion)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Generated locally · No server upload")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.glassBackground)
                    .shadow(color: .shadowColor, radius: 20, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.glassStroke, lineWidth: 1)
                    )
            )
            .padding(40)
        }
        .frame(width: 1080, height: 1920)
    }

    private func kpiCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.focusBlue)
                Text(title.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.system(size: 82, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .shadowColor, radius: 12, x: 0, y: 6)
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.focusBlue)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Simple Pie Chart
struct SharePieChart: View {
    let segments: [SharePlatform]

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 - 8
            let total = segments.reduce(0.0) { $0 + $1.percent }
            ZStack {
                let normalized = segments.map { ($0.name, ($0.percent / max(1, total)) * 2 * Double.pi) }
                ForEach(Array(normalized.enumerated()), id: \.offset) { index, item in
                    let start = normalized.prefix(index).reduce(-Double.pi / 2) { $0 + $1.1 }
                    let angle = item.1
                    Path { path in
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius,
                            startAngle: .radians(start),
                            endAngle: .radians(start + angle),
                            clockwise: false
                        )
                    }
                    .fill(sharePlatformColor(for: item.0))
                }
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: radius * 0.8, height: radius * 0.8)
            }
        }
    }
}

private func sharePlatformColor(for name: String) -> Color {
    switch name.lowercased() {
    case "youtube": return Color(red: 0.95, green: 0.13, blue: 0.13)
    case "reddit": return .orange
    case "instagram": return .purple
    case "facebook": return Color(red: 0.23, green: 0.35, blue: 0.60)
    case "x", "twitter": return Color(red: 0.13, green: 0.13, blue: 0.18)
    case "tiktok": return .black
    default: return .blue
    }
}

// MARK: - Simple Trend Chart
struct ShareTrendChart: View {
    let values: [Int]

    var body: some View {
        GeometryReader { geo in
            let maxVal = max(values.max() ?? 1, 1)
            let stepX = values.count > 1 ? geo.size.width / CGFloat(values.count - 1) : 0
            let points: [CGPoint] = values.enumerated().map { index, value in
                CGPoint(
                    x: CGFloat(index) * stepX,
                    y: geo.size.height - CGFloat(value) / CGFloat(maxVal) * geo.size.height
                )
            }
            ZStack {
                // Area
                Path { path in
                    guard let first = points.first, let last = points.last else { return }
                    path.move(to: CGPoint(x: first.x, y: geo.size.height))
                    path.addLine(to: first)
                    for p in points.dropFirst() { path.addLine(to: p) }
                    path.addLine(to: CGPoint(x: last.x, y: geo.size.height))
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.12))

                // Line
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for p in points.dropFirst() { path.addLine(to: p) }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

// MARK: - Renderer
@available(iOS 16.0, *)
@MainActor
func renderShareCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = ShareCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}


