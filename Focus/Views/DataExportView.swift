import SwiftUI
import UniformTypeIdentifiers

struct DataExportView: View {
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedFormat: ExportFormat = .csv
    @State private var selectedTimeRange: ExportTimeRange = .all
    @State private var isExporting = false
    @State private var exportError: String?
    @State private var showingActivityView = false
    @State private var exportedFileURL: URL?
    
    // Export content toggles
    @State private var includeSearchQueries = true
    @State private var includePlatformUsage = true  
    @State private var includeUsageStatistics = true
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case txt = "TXT"
        case json = "JSON"
        
        var fileExtension: String {
            switch self {
            case .csv: return "csv"
            case .txt: return "txt"
            case .json: return "json"
            }
        }
        
        var mimeType: String {
            switch self {
            case .csv: return "text/csv"
            case .txt: return "text/plain"
            case .json: return "application/json"
            }
        }
    }
    
    enum ExportTimeRange: String, CaseIterable {
        case week = "Last 7 Days"
        case month = "Last 30 Days"
        case all = "All Time"
        
        var days: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return nil
            }
        }
    }
    
    var filteredHistory: [SearchHistoryItem] {
        var history = searchHistoryManager.searchHistory
        
        if let days = selectedTimeRange.days {
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
            history = history.filter { $0.timestamp >= cutoffDate }
        }
        
        return history.sorted { $0.timestamp > $1.timestamp }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header info
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "square.and.arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Export Your Data")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Export your search history and usage statistics")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Data summary
                    HStack(spacing: 20) {
                        DataSummaryCard(
                            title: "Search History",
                            value: "\(filteredHistory.count)",
                            subtitle: "searches to export",
                            icon: "clock.arrow.circlepath"
                        )
                        
                        DataSummaryCard(
                            title: "Time Period",
                            value: selectedTimeRange.rawValue,
                            subtitle: getDateRangeText(),
                            icon: "calendar"
                        )
                    }
                }
                .padding(20)
                .background(Color(.systemGroupedBackground))
                
                // Export options
                Form {
                    Section("Export Format") {
                        Picker("Format", selection: $selectedFormat) {
                            ForEach(ExportFormat.allCases, id: \.self) { format in
                                HStack {
                                    Text(format.rawValue)
                                    Spacer()
                                    Text(".\(format.fileExtension)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .tag(format)
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                    }
                    
                    Section("Time Range") {
                        ForEach(ExportTimeRange.allCases, id: \.self) { range in
                            HStack {
                                Text(range.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedTimeRange == range {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.focusBlue)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTimeRange = range
                            }
                        }
                    }
                    
                    Section("Export Content") {
                        VStack(alignment: .leading, spacing: 12) {
                            ToggleableExportContentRow(
                                icon: "magnifyingglass",
                                title: "Search Queries",
                                description: "All your search terms and timestamps",
                                isSelected: $includeSearchQueries
                            )
                            
                            ToggleableExportContentRow(
                                icon: "square.grid.3x3",
                                title: "Platform Usage",
                                description: "Which platforms you searched most",
                                isSelected: $includePlatformUsage
                            )
                            
                            ToggleableExportContentRow(
                                icon: "chart.bar",
                                title: "Usage Statistics",
                                description: "Search counts and time saved data",
                                isSelected: $includeUsageStatistics
                            )
                        }
                        .padding(.vertical, 8)
                    }
                    
                    if let error = exportError {
                        Section {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                // Export button
                VStack(spacing: 16) {
                    Button(action: exportData) {
                        HStack {
                            if isExporting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "square.and.arrow.up")
                            }
                            
                            Text(isExporting ? "Exporting..." : "Export Data")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .disabled(isExporting || filteredHistory.isEmpty || (!includeSearchQueries && !includePlatformUsage && !includeUsageStatistics))
                    }
                    .padding(.horizontal, 20)
                    
                    if filteredHistory.isEmpty {
                        Text("No data available for the selected time range")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 30)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingActivityView) {
                if let url = exportedFileURL {
                    ActivityViewController(activityItems: [url])
                }
            }
        }
    }
    
    private func getDateRangeText() -> String {
        if selectedTimeRange == .all {
            return "since first use"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        if let days = selectedTimeRange.days,
           let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) {
            return "since \(formatter.string(from: startDate))"
        }
        
        return ""
    }
    
    private func exportData() {
        isExporting = true
        exportError = nil
        
        Task {
            do {
                let fileURL = try await generateExportFile()
                
                await MainActor.run {
                    exportedFileURL = fileURL
                    showingActivityView = true
                    isExporting = false
                }
            } catch {
                await MainActor.run {
                    exportError = "Export failed: \(error.localizedDescription)"
                    isExporting = false
                }
            }
        }
    }
    
    private func generateExportFile() async throws -> URL {
        let fileName = "SkipFeed_Export_\(formatDateForFileName(Date())).\(selectedFormat.fileExtension)"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        let content: String
        
        switch selectedFormat {
        case .csv:
            content = generateCSVContent()
        case .txt:
            content = generateTXTContent()
        case .json:
            content = try generateJSONContent()
        }
        
        try content.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
    
    private func generateCSVContent() -> String {
        var csv = ""
        
        if includeSearchQueries {
            csv += "Date,Time,Platform,Query,Search_Count\n"
            
            for item in filteredHistory {
                let date = DateFormatter.csvDateFormatter.string(from: item.timestamp)
                let time = DateFormatter.csvTimeFormatter.string(from: item.timestamp)
                let platform = item.platform.displayName
                let query = item.query.replacingOccurrences(of: "\"", with: "\"\"") // Escape quotes
                let searchCount = item.resultCount ?? 0
                
                csv += "\"\(date)\",\"\(time)\",\"\(platform)\",\"\(query)\",\(searchCount)\n"
            }
        }
        
        // Add platform usage summary
        if includePlatformUsage {
            if !csv.isEmpty { csv += "\n\n" }
            csv += "Platform Usage Summary:\n"
            csv += "Platform,Total_Searches,Percentage\n"
            
            let platforms = analyticsManager.getMostUsedPlatforms()
            let totalSearches = platforms.reduce(0) { $0 + $1.1 }
            
            for (platform, count) in platforms {
                let percentage = totalSearches > 0 ? (Double(count) / Double(totalSearches) * 100) : 0
                csv += "\"\(platform.displayName)\",\(count),\(String(format: "%.1f", percentage))%\n"
            }
        }
        
        // Add usage statistics
        if includeUsageStatistics {
            if !csv.isEmpty { csv += "\n\n" }
            csv += "Usage Statistics:\n"
            csv += "Metric,Value\n"
            csv += "\"Total Searches\",\(analyticsManager.getTotalSearches())\n"
            csv += "\"Today's Searches\",\(analyticsManager.getTodaysSearches())\n"
            csv += "\"Time Saved (minutes)\",\(Int(analyticsManager.getTimeSaved() / 60))\n"
            csv += "\"Today's Time Saved (minutes)\",\(Int(analyticsManager.getTimeSavedToday() / 60))\n"
        }
        
        return csv
    }
    
    private func generateTXTContent() -> String {
        var content = "SkipFeed Export Report\n"
        content += "Generated: \(DateFormatter.fullDateFormatter.string(from: Date()))\n"
        content += "Time Range: \(selectedTimeRange.rawValue)\n"
        if includeSearchQueries {
            content += "Total Searches: \(filteredHistory.count)\n"
        }
        content += String(repeating: "=", count: 50) + "\n\n"
        
        if includeSearchQueries {
            content += "SEARCH HISTORY:\n"
            content += String(repeating: "-", count: 20) + "\n"
            
            for item in filteredHistory {
                content += "Date: \(DateFormatter.fullDateFormatter.string(from: item.timestamp))\n"
                content += "Platform: \(item.platform.displayName)\n"
                content += "Query: \(item.query)\n"
                if let resultCount = item.resultCount {
                    content += "Results: \(resultCount)\n"
                }
                content += "\n"
            }
        }
        
        if includePlatformUsage {
            if includeSearchQueries { content += "\n" }
            content += "PLATFORM USAGE SUMMARY:\n"
            content += String(repeating: "-", count: 25) + "\n"
            
            let platforms = analyticsManager.getMostUsedPlatforms()
            let totalSearches = platforms.reduce(0) { $0 + $1.1 }
            
            for (platform, count) in platforms {
                let percentage = totalSearches > 0 ? (Double(count) / Double(totalSearches) * 100) : 0
                content += "\(platform.displayName): \(count) searches (\(String(format: "%.1f", percentage))%)\n"
            }
        }
        
        if includeUsageStatistics {
            if includeSearchQueries || includePlatformUsage { content += "\n" }
            content += "STATISTICS:\n"
            content += String(repeating: "-", count: 12) + "\n"
            content += "Total Searches: \(analyticsManager.getTotalSearches())\n"
            content += "Today's Searches: \(analyticsManager.getTodaysSearches())\n"
            content += "Time Saved: \(formatTimeSaved(analyticsManager.getTimeSaved()))\n"
            content += "Today's Time Saved: \(formatTimeSaved(analyticsManager.getTimeSavedToday()))\n"
        }
        
        return content
    }
    
    private func generateJSONContent() throws -> String {
        var exportData: [String: Any] = [
            "export_info": [
                "generated_at": ISO8601DateFormatter().string(from: Date()),
                "time_range": selectedTimeRange.rawValue,
                "format": "JSON",
                "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
                "included_content": [
                    "search_queries": includeSearchQueries,
                    "platform_usage": includePlatformUsage,
                    "usage_statistics": includeUsageStatistics
                ]
            ]
        ]
        
        if includeSearchQueries {
            exportData["search_history"] = filteredHistory.map { item in
                [
                    "id": item.id.uuidString,
                    "query": item.query,
                    "platform": item.platform.rawValue,
                    "platform_name": item.platform.displayName,
                    "timestamp": ISO8601DateFormatter().string(from: item.timestamp),
                    "result_count": item.resultCount as Any
                ]
            }
        }
        
        if includePlatformUsage {
            exportData["platform_usage"] = analyticsManager.getMostUsedPlatforms().map { platform, count in
                [
                    "platform": platform.rawValue,
                    "platform_name": platform.displayName,
                    "search_count": count
                ]
            }
        }
        
        if includeUsageStatistics {
            exportData["statistics"] = [
                "total_searches": analyticsManager.getTotalSearches(),
                "todays_searches": analyticsManager.getTodaysSearches(),
                "time_saved_seconds": analyticsManager.getTimeSaved(),
                "todays_time_saved_seconds": analyticsManager.getTimeSavedToday()
            ]
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: [.prettyPrinted, .sortedKeys])
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    private func formatDateForFileName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: date)
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
}

// MARK: - Supporting Views
struct DataSummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

struct ExportContentRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
    }
}

struct ToggleableExportContentRow: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSelected.toggle()
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .green : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Activity View Controller
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Date Formatters Extension
extension DateFormatter {
    static let csvDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let csvTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    DataExportView()
}
