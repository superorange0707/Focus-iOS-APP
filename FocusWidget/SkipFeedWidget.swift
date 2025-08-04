import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct SkipFeedWidgetEntry: TimelineEntry {
    let date: Date
    let totalSearches: Int
    let timeSaved: TimeInterval
    let todaySearches: Int
    let todayTimeSaved: TimeInterval
}

// MARK: - Widget Provider
struct SkipFeedWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SkipFeedWidgetEntry {
        SkipFeedWidgetEntry(
            date: Date(),
            totalSearches: 127,
            timeSaved: 6420, // 1h 47m
            todaySearches: 8,
            todayTimeSaved: 1440 // 24m
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SkipFeedWidgetEntry) -> ()) {
        let entry = loadCurrentStats()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SkipFeedWidgetEntry>) -> ()) {
        let currentEntry = loadCurrentStats()
        
        // Update every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [currentEntry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func loadCurrentStats() -> SkipFeedWidgetEntry {
        // Load analytics from UserDefaults (shared between app and widget)
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.focus.app"),
              let data = sharedDefaults.data(forKey: "usage_analytics"),
              let analytics = try? JSONDecoder().decode(UsageAnalytics.self, from: data) else {
            return SkipFeedWidgetEntry(
                date: Date(),
                totalSearches: 0,
                timeSaved: 0,
                todaySearches: 0,
                todayTimeSaved: 0
            )
        }

        return SkipFeedWidgetEntry(
            date: Date(),
            totalSearches: analytics.totalSearches,
            timeSaved: analytics.getTimeSaved(),
            todaySearches: analytics.getTodaysSearchCount(),
            todayTimeSaved: analytics.getTimeSavedToday()
        )
    }
}

// MARK: - Widget Views
struct SkipFeedWidgetSmallView: View {
    let entry: SkipFeedWidgetEntry

    var body: some View {
        VStack(spacing: 12) {
            // Icon and title
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)

                Spacer()

                Text("SkipFeed")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Main metric
            VStack(spacing: 4) {
                Text("\(entry.totalSearches)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Total Searches")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }

            Spacer()

            // Time saved
            HStack {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.green)

                Text(formatTime(entry.timeSaved))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.green)

                Text("saved")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct SkipFeedWidgetMediumView: View {
    let entry: SkipFeedWidgetEntry

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)

                    Text("SkipFeed")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                }

                Spacer()

                Text("Statistics")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }

            // Stats Grid
            HStack(spacing: 24) {
                // Today's Stats
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.orange)

                        Text("Today")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(entry.todaySearches)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("searches")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)

                        Text("\(formatTime(entry.todayTimeSaved)) saved")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.green)
                    }
                }

                Spacer()

                // Total Stats
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text("All Time")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.primary)

                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.purple)
                    }

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(entry.totalSearches)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("searches")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }

                    HStack(spacing: 4) {
                        Text("\(formatTime(entry.timeSaved)) saved")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.green)

                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Widget Configuration
struct SkipFeedWidget: Widget {
    let kind: String = "SkipFeedWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SkipFeedWidgetProvider()) { entry in
            SkipFeedWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("SkipFeed")
        .description("View your search statistics and time saved.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct SkipFeedWidgetEntryView: View {
    var entry: SkipFeedWidgetProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SkipFeedWidgetSmallView(entry: entry)
        case .systemMedium:
            SkipFeedWidgetMediumView(entry: entry)
        default:
            SkipFeedWidgetSmallView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle
@main
struct SkipFeedWidgetBundle: WidgetBundle {
    var body: some Widget {
        SkipFeedWidget()
    }
}

#Preview(as: .systemSmall) {
    SkipFeedWidget()
} timeline: {
    SkipFeedWidgetEntry(
        date: Date(),
        totalSearches: 127,
        timeSaved: 6420,
        todaySearches: 8,
        todayTimeSaved: 1440
    )
}

#Preview(as: .systemMedium) {
    SkipFeedWidget()
} timeline: {
    SkipFeedWidgetEntry(
        date: Date(),
        totalSearches: 127,
        timeSaved: 6420,
        todaySearches: 8,
        todayTimeSaved: 1440
    )
}
