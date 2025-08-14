import SwiftUI
import UIKit

// Import Charts only if available (iOS 16+)
#if canImport(Charts)
import Charts
#endif

// MARK: - Main Statistics View
struct StatisticsView: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingShareStudio = false
    
    enum TimeRange: String, CaseIterable {
        case week = "7d"
        case month = "30d"
        
        var displayName: String {
            switch self {
            case .week: return "7 Days"
            case .month: return "30 Days"
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.displayName).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    
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

                    // Platform Usage Pie Chart
                    if !analyticsManager.getMostUsedPlatforms().isEmpty {
                        PlatformUsagePieChartCard(
                            platforms: analyticsManager.getMostUsedPlatforms(),
                            timeRange: selectedTimeRange
                        )
                        .padding(.horizontal, 20)
                    }

                    // Trend Chart
                    SearchTrendChartCard(
                        timeRange: selectedTimeRange
                    )
                    .padding(.horizontal, 20)

                    // Time of Day Analysis
                    TimeOfDayAnalysisCard()
                        .padding(.horizontal, 20)

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
            .navigationTitle(localizationManager.localizedString(.statistics))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareStudio = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Share Studio")
                }
            }
            .sheet(isPresented: $showingShareStudio) {
                ShareStudioView()
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



// MARK: - Platform Usage Pie Chart
struct PlatformUsagePieChartCard: View {
    let platforms: [(Platform, Int)]
    let timeRange: StatisticsView.TimeRange
    @StateObject private var localizationManager = LocalizationManager.shared

    var chartData: [PlatformChartData] {
        let total = platforms.reduce(0) { $0 + $1.1 }
        return platforms.map { platform, count in
            PlatformChartData(
                platform: platform,
                count: count,
                percentage: Double(count) / Double(total) * 100
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .font(.title3)
                    .foregroundColor(.blue)

                Text(localizationManager.localizedString(.platformUsageStats))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
                
                Text(timeRange.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }

            HStack(spacing: 20) {
                // Pie Chart
                if #available(iOS 16.0, *) {
                    Chart(chartData, id: \.platform) { data in
                        SectorMark(
                            angle: .value("Count", data.count),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(data.platform.color)
                        .cornerRadius(4)
                    }
                    .frame(width: 120, height: 120)
                } else {
                    // Fallback for iOS 15
                    SimplePieChart(data: chartData)
                        .frame(width: 120, height: 120)
                }

                // Legend
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(chartData.prefix(4), id: \.platform) { data in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(data.platform.color)
                                .frame(width: 12, height: 12)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(data.platform.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)

                                Text("\(Int(data.percentage))% • \(data.count) searches")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Search Trend Chart
struct SearchTrendChartCard: View {
    let timeRange: StatisticsView.TimeRange
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared

    var chartData: [DailySearchData] {
        let days = timeRange == .week ? 7 : 30
        let calendar = Calendar.current
        let endDate = Date()
        
        var data: [DailySearchData] = []
        
        // Generate data for each day, starting from oldest to newest
        for dayOffset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: endDate) else { continue }
            let dateKey = DateFormatter.dayFormatter.string(from: date)
            let count = analyticsManager.analytics.dailySearches[dateKey] ?? 0
            
            data.append(DailySearchData(date: date, searchCount: count))
        }
        
        return data
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundColor(.blue)

                Text(localizationManager.localizedString(.searchTrend))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
                
                Text(timeRange.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }

            if #available(iOS 16.0, *) {
                Chart(chartData, id: \.date) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Searches", data.searchCount)
                    )
                    .foregroundStyle(.blue)
                    .lineStyle(.init(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Date", data.date),
                        y: .value("Searches", data.searchCount)
                    )
                    .foregroundStyle(.blue.opacity(0.1))
                }
                .frame(height: UIScreen.main.bounds.width < 400 ? 120 : 150) // Shorter on smaller iPhone screens
                .chartXAxis {
                    if timeRange == .week {
                        // Show all 7 days for week view
                        AxisMarks(preset: .aligned, values: chartData.map { $0.date }) { value in
                            AxisGridLine()
                            AxisTick()
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text(date, format: .dateTime.weekday(.abbreviated))
                                }
                            }
                        }
                    } else {
                        // Show fewer labels for month view to prevent overcrowding
                        AxisMarks(preset: .aligned, values: .stride(by: .day, count: 5)) { value in
                            AxisGridLine()
                            AxisTick()
                            if let date = value.as(Date.self) {
                                AxisValueLabel {
                                    Text(date, format: .dateTime.month(.abbreviated).day(.defaultDigits))
                                        .font(.caption2)
                                }
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
            } else {
                // Fallback for iOS 15
                SimpleLineChart(data: chartData, timeRange: timeRange)
                    .frame(height: UIScreen.main.bounds.width < 400 ? 120 : 150) // Shorter on smaller iPhone screens
            }
        }
        .padding(UIScreen.main.bounds.width < 400 ? 16 : 20) // Less padding on smaller screens
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Time of Day Analysis
struct TimeOfDayAnalysisCard: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var timeOfDayData: [TimeOfDayData] {
        let searchHistory = SearchHistoryManager.shared.searchHistory
        
        // Define time periods according to user's specification:
        // Morning: 3:00-11:30, Afternoon: 11:30-18:00, Evening: 18:00-3:00
        var morningCount = 0
        var afternoonCount = 0
        var eveningCount = 0
        
        let calendar = Calendar.current
        
        for item in searchHistory {
            let hour = calendar.component(.hour, from: item.timestamp)
            let minute = calendar.component(.minute, from: item.timestamp)
            let totalMinutes = hour * 60 + minute
            
            // Convert time to minutes for easier comparison
            // Morning: 3:00 (180) to 11:30 (690)
            // Afternoon: 11:30 (690) to 18:00 (1080) 
            // Evening: 18:00 (1080) to 3:00 (180 next day)
            
            if (totalMinutes >= 180 && totalMinutes < 690) {
                morningCount += 1
            } else if (totalMinutes >= 690 && totalMinutes < 1080) {
                afternoonCount += 1
            } else {
                eveningCount += 1
            }
        }
        
        return [
            TimeOfDayData(period: localizationManager.localizedString(.morningTime), searchCount: morningCount, icon: "sunrise.fill"),
            TimeOfDayData(period: localizationManager.localizedString(.afternoonTime), searchCount: afternoonCount, icon: "sun.max.fill"),
            TimeOfDayData(period: localizationManager.localizedString(.eveningTime), searchCount: eveningCount, icon: "moon.fill")
        ]
    }
    
    var mostActiveTime: String {
        let maxData = timeOfDayData.max { $0.searchCount < $1.searchCount }
        return maxData?.period.lowercased() ?? "evening"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .font(.title3)
                    .foregroundColor(.purple)

                Text(localizationManager.localizedString(.timeOfDayAnalysis))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            // Summary insight
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("You search most often in the \(mostActiveTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)

            // Time period breakdown
            VStack(spacing: 12) {
                ForEach(timeOfDayData, id: \.period) { data in
                    TimeOfDayRow(data: data, totalSearches: analyticsManager.getTotalSearches())
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Supporting Data Models
struct PlatformChartData {
    let platform: Platform
    let count: Int
    let percentage: Double
}

struct DailySearchData {
    let date: Date
    let searchCount: Int
}

struct TimeOfDayData {
    let period: String
    let searchCount: Int
    let icon: String
}

// MARK: - Supporting Views
struct TimeOfDayRow: View {
    let data: TimeOfDayData
    let totalSearches: Int
    
    var percentage: Double {
        guard totalSearches > 0 else { return 0 }
        return Double(data.searchCount) / Double(totalSearches) * 100
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: data.icon)
                .font(.title3)
                .foregroundColor(.purple)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(data.period)
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Spacer()

                    Text("\(data.searchCount) \(LocalizationManager.shared.localizedString(.searchesCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                ProgressView(value: percentage / 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                    .frame(height: 4)
            }
        }
    }
}

// MARK: - Fallback Charts for iOS 15
struct SimplePieChart: View {
    let data: [PlatformChartData]
    
    var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.offset) { index, chartData in
                let startAngle = data.prefix(index).reduce(0) { $0 + $1.percentage } * 3.6
                let endAngle = startAngle + chartData.percentage * 3.6
                
                Path { path in
                    let center = CGPoint(x: 60, y: 60)
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: 50,
                        startAngle: .degrees(startAngle - 90),
                        endAngle: .degrees(endAngle - 90),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .fill(chartData.platform.color)
            }
            
            Circle()
                .fill(Color(.systemBackground))
                .frame(width: 60, height: 60)
        }
    }
}

struct SimpleLineChart: View {
    let data: [DailySearchData]
    let timeRange: StatisticsView.TimeRange
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = Double(data.map(\.searchCount).max() ?? 1)
            let points = data.enumerated().map { index, item in
                CGPoint(
                    x: CGFloat(index) / CGFloat(data.count - 1) * geometry.size.width,
                    y: geometry.size.height - (CGFloat(item.searchCount) / CGFloat(maxValue) * geometry.size.height)
                )
            }
            
            ZStack {
                // Area fill
                Path { path in
                    guard let firstPoint = points.first else { return }
                    path.move(to: CGPoint(x: firstPoint.x, y: geometry.size.height))
                    path.addLine(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    if let lastPoint = points.last {
                        path.addLine(to: CGPoint(x: lastPoint.x, y: geometry.size.height))
                    }
                    path.closeSubpath()
                }
                .fill(Color.blue.opacity(0.1))
                
                // Line
                Path { path in
                    guard let firstPoint = points.first else { return }
                    path.move(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                
                // Data points for better visibility on smaller screens
                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    if timeRange == .week || index % 5 == 0 { // Show fewer points for 30-day view
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                            .position(x: point.x, y: point.y)
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
}
