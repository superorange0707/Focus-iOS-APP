import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct FocusWidgetEntry: TimelineEntry {
    let date: Date
    let totalSearches: Int
    let timeSaved: TimeInterval
    let todaySearches: Int
    let todayTimeSaved: TimeInterval
}

// MARK: - Widget Provider
struct FocusWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> FocusWidgetEntry {
        FocusWidgetEntry(
            date: Date(),
            totalSearches: 127,
            timeSaved: 6420, // 1h 47m
            todaySearches: 8,
            todayTimeSaved: 1440 // 24m
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FocusWidgetEntry) -> ()) {
        let entry = loadCurrentStats()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FocusWidgetEntry>) -> ()) {
        let currentEntry = loadCurrentStats()
        
        // Update every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [currentEntry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func loadCurrentStats() -> FocusWidgetEntry {
        // Load analytics from UserDefaults (shared between app and widget)
        guard let data = UserDefaults(suiteName: "group.com.focus.app")?.data(forKey: "usage_analytics"),
              let analytics = try? JSONDecoder().decode(UsageAnalytics.self, from: data) else {
            return FocusWidgetEntry(
                date: Date(),
                totalSearches: 0,
                timeSaved: 0,
                todaySearches: 0,
                todayTimeSaved: 0
            )
        }
        
        return FocusWidgetEntry(
            date: Date(),
            totalSearches: analytics.totalSearches,
            timeSaved: analytics.getTimeSaved(),
            todaySearches: analytics.getTodaysSearchCount(),
            todayTimeSaved: analytics.getTimeSavedToday()
        )
    }
}

// MARK: - Widget Views
struct FocusWidgetSmallView: View {
    let entry: FocusWidgetEntry
    
    var body: some View {
        VStack(spacing: 8) {
            // App icon and name
            HStack {
                Image("AppIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .cornerRadius(4)
                
                Text("SkipFeed")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.focusBlue)
                
                Spacer()
            }
            
            // Main stat
            VStack(spacing: 4) {
                Text("\(entry.totalSearches)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Total Searches")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Time saved
            VStack(spacing: 2) {
                Text(formatTime(entry.timeSaved))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Text("Time Saved")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
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

struct FocusWidgetMediumView: View {
    let entry: FocusWidgetEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Today's stats
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image("AppIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(6)
                    
                    Text("SkipFeed")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.focusBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(entry.todaySearches) searches")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("\(formatTime(entry.todayTimeSaved)) saved")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            
            // Right side - Total stats
            VStack(alignment: .trailing, spacing: 8) {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(entry.totalSearches)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("searches")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(formatTime(entry.timeSaved))")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Text("time saved")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
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
struct FocusWidget: Widget {
    let kind: String = "FocusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusWidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                FocusWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                FocusWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("SkipFeed Stats")
        .description("Track your search statistics and time saved with SkipFeed.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct FocusWidgetEntryView: View {
    var entry: FocusWidgetProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            FocusWidgetSmallView(entry: entry)
        case .systemMedium:
            FocusWidgetMediumView(entry: entry)
        default:
            FocusWidgetSmallView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle
@main
struct FocusWidgetBundle: WidgetBundle {
    var body: some Widget {
        FocusWidget()
    }
}

#Preview(as: .systemSmall) {
    FocusWidget()
} timeline: {
    FocusWidgetEntry(
        date: Date(),
        totalSearches: 127,
        timeSaved: 6420,
        todaySearches: 8,
        todayTimeSaved: 1440
    )
}

#Preview(as: .systemMedium) {
    FocusWidget()
} timeline: {
    FocusWidgetEntry(
        date: Date(),
        totalSearches: 127,
        timeSaved: 6420,
        todaySearches: 8,
        todayTimeSaved: 1440
    )
}
