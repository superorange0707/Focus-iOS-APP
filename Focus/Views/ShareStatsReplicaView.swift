import SwiftUI

// Renders a high-resolution replica of the in-app Statistics UI for sharing
struct ShareStatsReplicaView: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    var timeRange: StatisticsView.TimeRange = .week

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            VStack(spacing: 20) {
                // Hero
                HeroStatCard(
                    title: localizationManager.localizedString(.timeSaved),
                    value: formatTimeSaved(analyticsManager.getTimeSaved()),
                    subtitle: getLocalizedSubtitle(),
                    icon: "clock.badge.checkmark.fill",
                    gradient: [Color.green, Color.mint]
                )

                // Compact stats
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

                // Platform usage donut
                if !analyticsManager.getMostUsedPlatforms().isEmpty {
                    PlatformUsagePieChartCard(
                        platforms: analyticsManager.getMostUsedPlatforms(),
                        timeRange: timeRange
                    )
                }

                // Trend
                SearchTrendChartCard(timeRange: timeRange)

                // Time of day + insights
                TimeOfDayAnalysisCard()
                ModernInsightsCard(
                    todayTimeSaved: analyticsManager.getTimeSavedToday(),
                    totalSearches: analyticsManager.getTotalSearches()
                )
            }
            .padding(24)
        }
        .frame(width: 1080, height: 1920)
    }

    private func formatTimeSaved(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
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

#Preview {
    ShareStatsReplicaView()
}


