import SwiftUI
import UIKit

// MARK: - App Icon helper
extension UIImage {
    static var appIcon: UIImage? {
        guard let iconsDict = Bundle.main.infoDictionary?[("CFBundleIcons")] as? [String: Any],
              let primary = iconsDict[("CFBundlePrimaryIcon")] as? [String: Any],
              let iconFiles = primary[("CFBundleIconFiles")] as? [String],
              let last = iconFiles.last,
              let image = UIImage(named: last) else {
            return nil
        }
        return image
    }
}

// MARK: - Donut segment model
private struct DonutSegment: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let color: Color
}

// MARK: - Branded Share Card
struct BrandedShareCardView: View {
    let data: ShareCardData

    private var donutSegments: [DonutSegment] {
        let palette: [Color] = [.blue, .green, .orange, .purple, .pink, .teal]
        return data.topPlatforms.enumerated().map { idx, p in
            DonutSegment(name: p.name, value: max(0.001, p.percent), color: palette[idx % palette.count])
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 24) {
                // Header with app icon and slogan
                HStack(alignment: .center, spacing: 12) {
                    if let icon = UIImage.appIcon {
                        Image(uiImage: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                    } else {
                        Image(systemName: "swift")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SkipFeed")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("Skip the feed. Keep the focus.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(data.periodLabel)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }

                // Title and user
                VStack(alignment: .leading, spacing: 6) {
                    Text("Focus Report")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                    Text(data.displayName)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                // KPI row
                HStack(spacing: 16) {
                    kpiCard(title: "Time Saved", value: "\(data.todaySavedMin)m today", sub: "\(data.totalSavedMin)m total", icon: "clock.badge.checkmark.fill", color: .green)
                    kpiCard(title: "Focus Score", value: "\(data.focusScore)", sub: String(format: "Efficiency %.0f%%", data.efficiencyRate * 100), icon: "target", color: .blue)
                }

                // Charts row
                HStack(spacing: 16) {
                    donutCard
                    trendCard
                }

                // Badges (if any)
                if !data.badges.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(data.badges, id: \.self) { badge in
                                HStack(spacing: 6) {
                                    Image(systemName: badge.iconName)
                                    Text(badge.title)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }

                Spacer()

                // Footer
                HStack {
                    Spacer()
                    Text("Generated locally • No upload")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding(28)
        }
        .frame(width: 1080, height: 1920)
    }

    // MARK: - Subviews
    private func kpiCard(title: String, value: String, sub: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Image(systemName: icon).foregroundColor(color); Spacer() }
            Text(title).font(.subheadline).foregroundColor(.secondary)
            Text(value).font(.system(size: 32, weight: .bold, design: .rounded))
            Text(sub).font(.caption).foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var donutCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text("Top Platforms").font(.headline); Spacer() }
            HStack(spacing: 16) {
                DonutChart(segments: donutSegments)
                    .frame(width: 160, height: 160)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(donutSegments.prefix(4)) { seg in
                        HStack(spacing: 8) {
                            Circle().fill(seg.color).frame(width: 10, height: 10)
                            Text(seg.name).font(.caption)
                            Spacer()
                            Text(String(format: "%.0f%%", seg.value)).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var trendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text("Trend").font(.headline); Spacer() }
            Sparkline(values: data.trend.map { Double($0) })
                .frame(height: 120)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Donut chart
private struct DonutChart: View {
    let segments: [DonutSegment]

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            let radius = min(geo.size.width, geo.size.height)/2
            let total = segments.map { $0.value }.reduce(0, +)
            ZStack {
                ForEach(Array(segments.enumerated()), id: \.offset) { index, seg in
                    let start = segments.prefix(index).map { $0.value }.reduce(0, +) / max(0.001, total) * 2 * Double.pi - Double.pi/2
                    let end = (segments.prefix(index+1).map { $0.value }.reduce(0, +) / max(0.001, total)) * 2 * Double.pi - Double.pi/2
                    Path { path in
                        path.addArc(center: center, radius: radius, startAngle: .radians(start), endAngle: .radians(end), clockwise: false)
                    }
                    .stroke(seg.color, lineWidth: radius * 0.35)
                }
                Circle().fill(Color(.systemBackground)).frame(width: radius*1.0, height: radius*1.0)
            }
        }
    }
}

// MARK: - Sparkline
private struct Sparkline: View {
    let values: [Double]
    var body: some View {
        GeometryReader { geo in
            let maxVal = max(values.max() ?? 1, 1)
            let minVal = min(values.min() ?? 0, maxVal)
            let range = max(maxVal - minVal, 1)
            let points = values.enumerated().map { idx, v in
                CGPoint(x: CGFloat(idx) / CGFloat(max(values.count - 1, 1)) * geo.size.width,
                        y: geo.size.height - CGFloat((v - minVal) / range) * geo.size.height)
            }
            ZStack {
                Path { p in
                    guard let first = points.first else { return }
                    p.move(to: CGPoint(x: first.x, y: geo.size.height))
                    p.addLine(to: first)
                    for pt in points.dropFirst() { p.addLine(to: pt) }
                    if let last = points.last { p.addLine(to: CGPoint(x: last.x, y: geo.size.height)) }
                }
                .fill(Color.blue.opacity(0.12))

                Path { p in
                    guard let first = points.first else { return }
                    p.move(to: first)
                    for pt in points.dropFirst() { p.addLine(to: pt) }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

// MARK: - Renderer
@available(iOS 16.0, *)
@MainActor
func renderBrandedShareCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = BrandedShareCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}



