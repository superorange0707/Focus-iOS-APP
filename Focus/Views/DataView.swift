import SwiftUI

struct DataView: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedTab: DataTab = .stats
    
    enum DataTab: String, CaseIterable {
        case stats = "stats"
        case history = "history"
        
        func title(using localizationManager: LocalizationManager) -> String {
            switch self {
            case .stats: return localizationManager.localizedString(.stats)
            case .history: return localizationManager.localizedString(.searchHistory)
            }
        }
        
        var icon: String {
            switch self {
            case .stats: return "chart.bar.fill"
            case .history: return "clock.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Tab Selector
                HStack(spacing: 0) {
                    ForEach(DataTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: tab.icon)
                                    .font(.title3)
                                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                                
                                Text(tab.title(using: localizationManager))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTab == tab ? .blue : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Group {
                                    if selectedTab == tab {
                                        if tab == .history {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(LinearGradient(colors: [Color.blue.opacity(0.15), Color.blue.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                                )
                                        } else {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.blue.opacity(0.1))
                                        }
                                    } else {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.clear)
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .background(Color(.systemGroupedBackground))
                
                // Content
                TabView(selection: $selectedTab) {
                    // Statistics Tab
                    StatsTabContent()
                        .tag(DataTab.stats)
                    
                    // History Tab
                    HistoryTabContent()
                        .tag(DataTab.history)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle(localizationManager.localizedString(.data))
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
    

}

struct StatsTabContent: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var premiumManager = PremiumManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Hero Stats
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(localizationManager.localizedString(.stats))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)

                        Spacer()
                    }

                    HStack(spacing: 16) {
                        HeroStatCard(
                            title: localizationManager.localizedString(.totalSearches),
                            value: "\(analyticsManager.getTotalSearches())",
                            subtitle: getLocalizedSubtitle(),
                            icon: "magnifyingglass",
                            gradient: [.blue, .blue.opacity(0.7)]
                        )
                        .frame(maxWidth: .infinity)

                        HeroStatCard(
                            title: localizationManager.localizedString(.today),
                            value: "\(analyticsManager.getTodaysSearches())",
                            subtitle: getLocalizedSubtitle(),
                            icon: "calendar",
                            gradient: [.orange, .orange.opacity(0.7)]
                        )
                        .frame(maxWidth: .infinity)
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

struct HistoryTabContent: View {
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @State private var selectedPlatform: Platform? = nil
    @State private var isSelectionMode = false
    @State private var selectedItems: Set<UUID> = []
    @State private var searchText = ""
    @State private var showSettings = false
    @State private var showDateGrouping = true
    @State private var autoCleanupDays = 30
    @State private var itemsToShow = 50

    // Computed properties for statistics
    private var todayCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return searchHistoryManager.searchHistory.filter { item in
            Calendar.current.isDate(item.timestamp, inSameDayAs: today)
        }.count
    }

    private var thisWeekCount: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        return searchHistoryManager.searchHistory.filter { item in
            item.timestamp >= weekAgo
        }.count
    }

    private var thisMonthCount: Int {
        let calendar = Calendar.current
        let now = Date()
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        return searchHistoryManager.searchHistory.filter { item in
            item.timestamp >= monthAgo
        }.count
    }

    var body: some View {
        VStack(spacing: 0) {

            // Search bar and controls
            HStack(spacing: 12) {
                // Search bar container
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16, weight: .medium))

                    TextField("Search history...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.33)
                )

                // Group/List toggle button
                Button(action: {
                    showDateGrouping.toggle()
                }) {
                    Image(systemName: showDateGrouping ? "list.bullet" : "rectangle.grid.1x2")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemGroupedBackground))
                                .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator), lineWidth: 0.33)
                        )
                }

                // Settings button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSettings.toggle()
                    }
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemGroupedBackground))
                                .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 0.5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator), lineWidth: 0.33)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            // Settings panel
            if showSettings {
                VStack(spacing: 16) {
                    // History Settings header
                    HStack {
                        Text("History Settings")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                    }

                    // Auto-cleanup setting
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Auto-cleanup")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            Text("Delete items older than \(autoCleanupDays) days")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("7")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)

                            Slider(value: Binding(
                                get: { Double(autoCleanupDays) },
                                set: { autoCleanupDays = Int($0) }
                            ), in: 7...365, step: 1)
                            .accentColor(.blue)

                            Text("365")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }

                    // Statistics section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Statistics")
                            .font(.system(size: 16, weight: .medium))

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Total: \(searchHistoryManager.searchHistory.count)")
                                    .font(.system(size: 14))
                                Text("Today: \(todayCount)")
                                    .font(.system(size: 14))
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("This Week: \(thisWeekCount)")
                                    .font(.system(size: 14))
                                Text("This Month: \(thisMonthCount)")
                                    .font(.system(size: 14))
                            }
                        }
                        .foregroundColor(.secondary)
                    }

                    // Action buttons
                    HStack(spacing: 16) {
                        Button("Clean Old Items") {
                            cleanOldItems()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)

                        Button("Clean Invalid") {
                            searchHistoryManager.cleanupInvalidEntries()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.orange)

                        Spacer()

                        Button("Done") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSettings = false
                            }
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.33)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            // Header with Platform Filter and Clear All button
            VStack(spacing: 12) {
                // Platform Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // All platforms button
                        FilterChip(
                            title: localizationManager.localizedString(.allPlatforms),
                            isSelected: selectedPlatform == nil
                        ) {
                            selectedPlatform = nil
                        }

                        // Individual platform filters
                        ForEach(Platform.allCases, id: \.self) { platform in
                            FilterChip(
                                title: platform.displayName,
                                isSelected: selectedPlatform == platform
                            ) {
                                selectedPlatform = platform
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)

                // Action buttons (only show if there's history)
                if !analyticsManager.getRecentSearchHistory().isEmpty {
                    HStack {
                        if isSelectionMode {
                            // Selection mode controls
                            Button(action: {
                                // Select all
                                selectedItems = Set(getFilteredHistory().map { $0.id })
                            }) {
                                Text("Select All")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.focusBlue)
                            }

                            Spacer()

                            Button(action: {
                                // Delete selected
                                searchHistoryManager.deleteItems(withIds: selectedItems)
                                selectedItems.removeAll()
                                isSelectionMode = false
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("Delete (\(selectedItems.count))")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(6)
                            }
                            .disabled(selectedItems.isEmpty)
                            .opacity(selectedItems.isEmpty ? 0.5 : 1.0)

                            Button(action: {
                                // Cancel selection
                                selectedItems.removeAll()
                                isSelectionMode = false
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            // Normal mode controls
                            Button(action: {
                                // Enter selection mode
                                isSelectionMode = true
                            }) {
                                Text("Select")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.focusBlue)
                            }

                            Spacer()

                            Button(action: {
                                // Clear all search history
                                searchHistoryManager.clearHistory()
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 12, weight: .medium))
                                    Text("Clear All")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    .animation(.easeInOut(duration: 0.2), value: isSelectionMode)
                }
            }
            .padding(.top, 16)
            .background(Color(.systemGroupedBackground))
            
            // Search History List
            let filteredHistory = getFilteredHistory()

            if filteredHistory.isEmpty {
                VStack(spacing: 20) {
                    Spacer()

                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    VStack(spacing: 8) {
                        Text("No search history yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Text("Your search history will appear here after you perform searches")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if showDateGrouping {
                            // Grouped view
                            ForEach(groupedHistory(), id: \.0) { groupName, items in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Group header
                                    HStack {
                                        Text(groupName)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.primary)

                                        Spacer()

                                        Text("\(items.count)")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, groupName == groupedHistory().first?.0 ? 0 : 16)

                                    // Group items
                                    ForEach(items, id: \.id) { item in
                                        SearchHistoryRow(
                                            item: item,
                                            onRepeatSearch: {
                                                // Handle repeat search
                                                let _ = SearchService.shared.directSearch(query: item.query, platform: item.platform)
                                            },
                                            onDelete: isSelectionMode ? nil : {
                                                // Delete individual item properly
                                                searchHistoryManager.deleteItem(withId: item.id)
                                            },
                                            isSelectionMode: isSelectionMode,
                                            isSelected: selectedItems.contains(item.id),
                                            onSelectionToggle: {
                                                if selectedItems.contains(item.id) {
                                                    selectedItems.remove(item.id)
                                                } else {
                                                    selectedItems.insert(item.id)
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                        } else {
                            // Flat list view
                            ForEach(filteredHistory, id: \.id) { item in
                                SearchHistoryRow(
                                    item: item,
                                    onRepeatSearch: {
                                        // Handle repeat search
                                        let _ = SearchService.shared.directSearch(query: item.query, platform: item.platform)
                                    },
                                    onDelete: isSelectionMode ? nil : {
                                        // Delete individual item properly
                                        searchHistoryManager.deleteItem(withId: item.id)
                                    },
                                    isSelectionMode: isSelectionMode,
                                    isSelected: selectedItems.contains(item.id),
                                    onSelectionToggle: {
                                        if selectedItems.contains(item.id) {
                                            selectedItems.remove(item.id)
                                        } else {
                                            selectedItems.insert(item.id)
                                        }
                                    }
                                )
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private func getFilteredHistory() -> [SearchHistoryItem] {
        let allHistory = analyticsManager.getRecentSearchHistory()

        var filtered = allHistory

        // Filter by platform
        if let platform = selectedPlatform {
            filtered = filtered.filter { $0.platform == platform }
        }

        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.query.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered
    }

    private func cleanOldItems() {
        searchHistoryManager.cleanupOldHistory(olderThan: autoCleanupDays)
    }

    private func groupedHistory() -> [(String, [SearchHistoryItem])] {
        let filtered = getFilteredHistory()
        let calendar = Calendar.current
        let now = Date()

        var groups: [String: [SearchHistoryItem]] = [:]

        for item in filtered {
            let key: String
            if calendar.isDateInToday(item.timestamp) {
                key = "Today"
            } else if calendar.isDateInYesterday(item.timestamp) {
                key = "Yesterday"
            } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(item.timestamp) == true {
                key = "This Week"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                key = formatter.string(from: item.timestamp)
            }

            if groups[key] == nil {
                groups[key] = []
            }
            groups[key]?.append(item)
        }

        // Sort groups by date (most recent first)
        let sortedGroups = groups.map { (key, items) in
            (key, items.sorted { $0.timestamp > $1.timestamp })
        }.sorted { (group1, group2) in
            // Custom sorting for groups
            let order = ["Today", "Yesterday", "This Week"]
            if let index1 = order.firstIndex(of: group1.0), let index2 = order.firstIndex(of: group2.0) {
                return index1 < index2
            } else if order.contains(group1.0) {
                return true
            } else if order.contains(group2.0) {
                return false
            } else {
                // For date strings, compare the first item's timestamp
                let date1 = group1.1.first?.timestamp ?? Date.distantPast
                let date2 = group2.1.first?.timestamp ?? Date.distantPast
                return date1 > date2
            }
        }

        return sortedGroups
    }
    

}



#Preview {
    DataView()
}
