import SwiftUI

// MARK: - Search History View
struct SearchHistoryView: View {
    let onExecuteSearch: ((String, Platform) -> Void)?

    @StateObject private var searchHistoryManager = SearchHistoryManager.shared
    @StateObject private var searchService = SearchService.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedPlatform: Platform?
    @State private var selectedTimeFilter: TimeFilter = .all
    @State private var isSelectionMode = false
    @State private var selectedItems: Set<UUID> = []
    
    enum TimeFilter: String, CaseIterable {
        case today = "Today"
        case yesterday = "Yesterday"
        case week = "This Week"
        case month = "This Month"
        case all = "All Time"
        
        var icon: String {
            switch self {
            case .today: return "sun.max.fill"
            case .yesterday: return "moon.fill"
            case .week: return "calendar.circle.fill"
            case .month: return "calendar"
            case .all: return "clock.fill"
            }
        }
        
        func filterPredicate(for date: Date) -> Bool {
            let calendar = Calendar.current
            let now = Date()
            
            switch self {
            case .today:
                return calendar.isDate(date, inSameDayAs: now)
            case .yesterday:
                guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else { return false }
                return calendar.isDate(date, inSameDayAs: yesterday)
            case .week:
                return calendar.dateInterval(of: .weekOfYear, for: now)?.contains(date) == true
            case .month:
                return calendar.dateInterval(of: .month, for: now)?.contains(date) == true
            case .all:
                return true
            }
        }
    }

    init(onExecuteSearch: ((String, Platform) -> Void)? = nil) {
        self.onExecuteSearch = onExecuteSearch
    }
    
    var filteredHistory: [SearchHistoryItem] {
        var history = searchHistoryManager.searchHistory
        
        // Filter by search text
        if !searchText.isEmpty {
            history = history.filter { item in
                item.query.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by platform
        if let platform = selectedPlatform {
            history = history.filter { $0.platform == platform }
        }
        
        // Filter by time
        history = history.filter { item in
            selectedTimeFilter.filterPredicate(for: item.timestamp)
        }
        
        return history
    }
    
    var groupedHistory: [String: [SearchHistoryItem]] {
        let calendar = Calendar.current
        var grouped: [String: [SearchHistoryItem]] = [:]
        
        for item in filteredHistory {
            let dateKey = calendar.dateInterval(of: .day, for: item.timestamp)?.start ?? item.timestamp
            let keyString = DateFormatter.dayFormatter.string(from: dateKey)
            
            if grouped[keyString] == nil {
                grouped[keyString] = []
            }
            grouped[keyString]?.append(item)
        }
        
        // Sort items within each day by timestamp (newest first)
        for key in grouped.keys {
            grouped[key] = grouped[key]?.sorted { $0.timestamp > $1.timestamp }
        }
        
        return grouped
    }
    
    func formatSectionDate(_ dateString: String) -> String {
        guard let date = DateFormatter.dayFormatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(date) == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Full weekday name
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter bar
                VStack(spacing: 4) {
                    // Search bar with time filter
                    HStack(spacing: 12) {
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondaryText)
                            
                            TextField(localizationManager.localizedString(.searchHistory_placeholder), text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondaryText)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        
                        // Time filter
                        Menu {
                            ForEach(TimeFilter.allCases, id: \.self) { timeFilter in
                                Button {
                                    selectedTimeFilter = timeFilter
                                } label: {
                                    HStack {
                                        Image(systemName: timeFilter.icon)
                                        Text(timeFilter.rawValue)
                                        Spacer()
                                        if selectedTimeFilter == timeFilter {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.focusBlue)
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: selectedTimeFilter.icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.focusBlue)
                                .frame(width: 48, height: 48) // Match search bar height
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20) // Add consistent padding
                    
                    // Platform filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // All platforms button
                            FilterChip(
                                title: "All",
                                isSelected: selectedPlatform == nil,
                                action: { selectedPlatform = nil }
                            )
                            
                            // Individual platform filters
                            ForEach(Platform.allCases, id: \.self) { platform in
                                FilterChip(
                                    title: platform.displayName,
                                    isSelected: selectedPlatform == platform,
                                    action: { 
                                        selectedPlatform = selectedPlatform == platform ? nil : platform
                                    }
                                )
                            }
                        }
                        .padding(.leading, 20) // Only left padding to align with content
                        .padding(.trailing, 20) // Right padding for scrolling
                    }
                    
                    // Action buttons - Clear All absolutely to edge
                    if !searchHistoryManager.searchHistory.isEmpty {
                        ZStack {
                            // Left side buttons - aligned with content
                            HStack {
                                HStack(spacing: 8) {
                                    Button(isSelectionMode ? "Cancel" : "Select") {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isSelectionMode.toggle()
                                            if !isSelectionMode {
                                                selectedItems.removeAll()
                                            }
                                        }
                                    }
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.focusBlue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.focusBlue.opacity(0.1))
                                    .cornerRadius(14)
                                    
                                    // Select All button (only in selection mode)
                                    if isSelectionMode {
                                        Button(selectedItems.count == filteredHistory.count ? "Deselect All" : "Select All") {
                                            if selectedItems.count == filteredHistory.count {
                                                selectedItems.removeAll()
                                            } else {
                                                selectedItems = Set(filteredHistory.map { $0.id })
                                            }
                                        }
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.focusBlue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.focusBlue.opacity(0.1))
                                        .cornerRadius(14)
                                    }
                                }
                                .padding(.leading, 20) // Left padding for Select button
                                
                                Spacer()
                            }
                            
                            // Right side buttons - absolutely to edge
                            HStack {
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    // Delete selected button (only in selection mode)
                                    if isSelectionMode && !selectedItems.isEmpty {
                                        Button("Delete (\(selectedItems.count))") {
                                            searchHistoryManager.deleteItems(withIds: selectedItems)
                                            selectedItems.removeAll()
                                            isSelectionMode = false
                                        }
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(14)
                                    }
                                    
                                    // Clear All button (only when not in selection mode)
                                    if !isSelectionMode {
                                        Button("Clear All") {
                                            searchHistoryManager.clearHistory()
                                        }
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(14)
                                    }
                                }
                                .padding(.trailing, 16) // Minimal right padding for absolute edge
                            }
                        }
                        .padding(.top, 4) // Minimal top spacing
                        .padding(.bottom, 0)
                    }
                }
                .padding(.top, 4) // Minimal top padding to bring very close to title
                .padding(.bottom, 0) // No bottom padding
                .background(Color.backgroundPrimary)
                
                // History list
                if filteredHistory.isEmpty {
                    EmptyHistoryView(hasSearches: !searchHistoryManager.searchHistory.isEmpty)
                } else {
                    List {
                        ForEach(groupedHistory.keys.sorted { $0 > $1 }, id: \.self) { dateKey in
                            Section {
                                ForEach(groupedHistory[dateKey] ?? []) { item in
                                    SearchHistoryRow(
                                        item: item,
                                        onRepeatSearch: {
                                            // Use callback if available, otherwise fall back to direct search
                                            if let onExecuteSearch = onExecuteSearch {
                                                onExecuteSearch(item.query, item.platform)
                                            } else {
                                                searchService.directSearch(query: item.query, platform: item.platform)
                                            }
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
                                }
                            } header: {
                                Text(formatSectionDate(dateKey))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                    .textCase(nil)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredHistory[$0].id }
        searchHistoryManager.deleteItems(withIds: Set(itemsToDelete))
    }
}

// MARK: - Search History Row
struct SearchHistoryRow: View {
    let item: SearchHistoryItem
    let onRepeatSearch: () -> Void
    let onDelete: (() -> Void)?
    let isSelectionMode: Bool
    let isSelected: Bool
    let onSelectionToggle: (() -> Void)?

    init(
        item: SearchHistoryItem,
        onRepeatSearch: @escaping () -> Void,
        onDelete: (() -> Void)? = nil,
        isSelectionMode: Bool = false,
        isSelected: Bool = false,
        onSelectionToggle: (() -> Void)? = nil
    ) {
        self.item = item
        self.onRepeatSearch = onRepeatSearch
        self.onDelete = onDelete
        self.isSelectionMode = isSelectionMode
        self.isSelected = isSelected
        self.onSelectionToggle = onSelectionToggle
    }

    var body: some View {
        HStack(spacing: 12) {
            // Selection circle (in selection mode)
            if isSelectionMode {
                Button(action: {
                    onSelectionToggle?()
                }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .focusBlue : .secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Platform icon
            Image(item.platform.assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .background(Color.cardBackground)
                .cornerRadius(8)

            // Search details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.query)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                HStack {
                    Text(item.platform.displayName)
                        .font(.caption)
                        .foregroundColor(.focusBlue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.focusBlue.opacity(0.1))
                        .cornerRadius(4)

                    Text(item.detailedTimeString)
                        .font(.caption)
                        .foregroundColor(.secondaryText)

                    Spacer()
                }
            }
            
            Spacer()

            // Action buttons (hidden in selection mode)
            if !isSelectionMode {
                HStack(spacing: 12) {
                    // Delete button
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                                .frame(width: 32, height: 32)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    // Repeat search button
                    Button(action: onRepeatSearch) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.focusBlue)
                            .frame(width: 32, height: 32)
                            .background(Color.focusBlue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelectionMode {
                onSelectionToggle?()
            } else {
                onRepeatSearch()
            }
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .focusBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.focusBlue : Color.focusBlue.opacity(0.1))
                .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Empty History View
struct EmptyHistoryView: View {
    let hasSearches: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasSearches ? "magnifyingglass" : "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(.secondaryText)
            
            Text(hasSearches ? "No matching searches" : "No search history yet")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.secondaryText)
            
            Text(hasSearches ? "Try adjusting your search or filters" : "Your search history will appear here after you perform searches")
                .font(.subheadline)
                .foregroundColor(.tertiaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    SearchHistoryView()
}
