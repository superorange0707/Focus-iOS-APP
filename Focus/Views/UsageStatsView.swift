import SwiftUI

// MARK: - Usage Statistics View
struct UsageStatsView: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Hero Stats Section
                    VStack(spacing: 16) {
                        HeroStatCard(
                            title: localizationManager.localizedString(.timeSaved),
                            value: formatTimeSaved(analyticsManager.getTimeSaved()),
                            subtitle: getLocalizedSubtitle(),
                            icon: "clock.badge.checkmark.fill",
                            gradient: [Color.green, Color.mint]
                        )

                        HStack(spacing: 12) {
                            CompactStatCard(
                                title: localizationManager.localizedString(.totalSearches),
                                value: "\(analyticsManager.getTotalSearches())",
                                icon: "magnifyingglass.circle.fill",
                                color: .blue
                            )

                            CompactStatCard(
                                title: localizationManager.localizedString(.today),
                                value: "\(analyticsManager.getTodaysSearches())",
                                icon: "calendar.circle.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Platform Usage Section
                    if !analyticsManager.getMostUsedPlatforms().isEmpty {
                        ModernPlatformUsageCard(platforms: analyticsManager.getMostUsedPlatforms())
                            .padding(.horizontal, 20)
                    }

                    // Insights Section
                    ModernInsightsCard(
                        todayTimeSaved: analyticsManager.getTimeSavedToday(),
                        totalSearches: analyticsManager.getTotalSearches()
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your Stats")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private func formatTimeSaved(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    private func getLocalizedSubtitle() -> String {
        switch localizationManager.currentLanguage {
        case "es": return "vs desplazamiento infinito"
        case "fr": return "vs défilement infini"
        case "de": return "vs endloses Scrollen"
        case "it": return "vs scorrimento infinito"
        case "pt": return "vs rolagem infinita"
        case "ru": return "vs бесконечная прокрутка"
        case "ja": return "vs 無限スクロール"
        case "ko": return "vs 무한 스크롤"
        case "zh": return "vs 无限滚动"
        default: return "vs endless scrolling"
        }
    }
}

// MARK: - Modern Card Components

struct HeroStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let gradient: [Color]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundStyle(.white)

                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Text(value)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                }

                Spacer()
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

struct CompactStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            VStack(spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernPlatformUsageCard: View {
    let platforms: [(Platform, Int)]
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(.blue)

                Text(localizationManager.localizedString(.platformUsage))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                ForEach(Array(platforms.prefix(3).enumerated()), id: \.offset) { index, platformData in
                    let (platform, count) = platformData
                    ModernPlatformRow(
                        platform: platform,
                        searchCount: count,
                        rank: index + 1,
                        isTop: index == 0,
                        platforms: platforms
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ModernPlatformRow: View {
    let platform: Platform
    let searchCount: Int
    let rank: Int
    let isTop: Bool
    let platforms: [(Platform, Int)] // Add this to access the full list
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        HStack(spacing: 16) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(isTop ? Color.yellow : Color.gray.opacity(0.2))
                    .frame(width: 32, height: 32)

                if isTop {
                    Image(systemName: "crown.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                } else {
                    Text("\(rank)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }

            // Platform info
            HStack(spacing: 12) {
                Image(platform.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(platform.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text(localizationManager.formatSearchCount(searchCount))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Progress indicator
            let maxCount = platforms.first?.1 ?? 1
            let progress = Double(searchCount) / Double(maxCount)

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: platform.color))
                .frame(width: 60)
        }
        .padding(.vertical, 4)
    }
}



struct ModernInsightsCard: View {
    let todayTimeSaved: TimeInterval
    let totalSearches: Int
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.circle.fill")
                    .font(.title3)
                    .foregroundColor(.yellow)

                Text(localizationManager.localizedString(.insights))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            VStack(spacing: 12) {
                InsightRow(
                    icon: "target",
                    title: localizationManager.localizedString(.focusScore),
                    value: "\(min(100, totalSearches * 2))%",
                    description: localizationManager.localizedString(.stayingFocused)
                )

                InsightRow(
                    icon: "clock.arrow.circlepath",
                    title: localizationManager.localizedString(.todaysImpact),
                    value: formatTime(todayTimeSaved),
                    description: localizationManager.localizedString(.timeSavedFromDistractions)
                )

                InsightRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: localizationManager.localizedString(.efficiency),
                    value: getLocalizedEfficiencyValue(),
                    description: localizationManager.localizedString(.directSearchesSaveTime)
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        return "\(minutes)m"
    }

    private func getLocalizedEfficiencyValue() -> String {
        switch localizationManager.currentLanguage {
        case "es": return "Alto"
        case "fr": return "Élevé"
        case "de": return "Hoch"
        case "it": return "Alto"
        case "pt": return "Alto"
        case "ru": return "Высокий"
        case "ja": return "高い"
        case "ko": return "높음"
        case "zh": return "高"
        default: return "High"
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Spacer()

                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    UsageStatsView()
}
