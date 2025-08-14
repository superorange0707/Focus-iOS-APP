import SwiftUI
import UIKit

struct ShareStudioView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var analyticsManager = UsageAnalyticsManager.shared

    enum Template: String, CaseIterable, Identifiable {
        case achievement = "Achievement"
        case progress = "Progress"
        case challenge = "Challenge"
        case social = "Social"
        var id: String { rawValue }
    }

    @State private var template: Template = .achievement
    @State private var includeCoreStats = true
    @State private var includePlatforms = true
    @State private var includeTrend = true
    @State private var includeTimeOfDay = false
    @State private var includeInsights = false
    @State private var includeAchievements = true
    @State private var includeChallenges = false
    @State private var previewImage: UIImage?
    @State private var showingShare = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    // Template Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("STYLE")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        Picker("Template", selection: $template) {
                            ForEach(Template.allCases) { t in
                                Text(t.rawValue).tag(t)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding(.horizontal, 20)

                    // Module Toggles
                    VStack(alignment: .leading, spacing: 12) {
                        Text("MODULES")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                        
                        VStack(spacing: 0) {
                            Toggle("Core Stats", isOn: $includeCoreStats)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Platforms", isOn: $includePlatforms)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Trend", isOn: $includeTrend)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Time of Day", isOn: $includeTimeOfDay)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Insights", isOn: $includeInsights)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Achievements", isOn: $includeAchievements)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                            
                            Divider()
                                .padding(.leading, 16)
                            
                            Toggle("Challenges", isOn: $includeChallenges)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                        }
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: 360)

                Divider()

                ScrollView {
                    if let img = previewImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                            .padding()
                    } else {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Generating preview…")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 240)
                    }
                }
            }
            .navigationTitle("Share Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share…") { share() }
                        .disabled(previewImage == nil)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveToPhotos() }
                        .disabled(previewImage == nil)
                }
            }
            .onAppear { regenerate() }
            .onChange(of: template) { regenerate() }
            .onChange(of: includeCoreStats) { regenerate() }
            .onChange(of: includePlatforms) { regenerate() }
            .onChange(of: includeTrend) { regenerate() }
            .onChange(of: includeTimeOfDay) { regenerate() }
            .onChange(of: includeInsights) { regenerate() }
            .onChange(of: includeAchievements) { regenerate() }
            .onChange(of: includeChallenges) { regenerate() }
        }
        .sheet(isPresented: $showingShare) {
            if let image = previewImage {
                ActivityViewController(activityItems: [image])
            }
        }
    }

    private func regenerate() {
        guard #available(iOS 16.0, *) else { return }
        previewImage = nil
        let data = buildShareData()
        
        // Choose renderer by template and module selection
        switch template {
        case .achievement:
            previewImage = renderAchievementCardPNG(data)
        case .progress:
            previewImage = renderProgressCardPNG(data)
        case .challenge:
            previewImage = renderChallengeCardPNG(data)
        case .social:
            previewImage = renderSocialCardPNG(data)
        }
    }

    private func share() { showingShare = true }

    private func saveToPhotos() {
        guard let image = previewImage else { return }
        // Ensure save operation runs on main thread to avoid SwiftUI crashes
        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    private func buildShareData() -> ShareCardData {
        let name = "User-\(UIDevice.current.identifierForVendor?.uuidString.prefix(4) ?? "0000")"
        let period = "Custom"
        let todayMin = Int(analyticsManager.getTimeSavedToday() / 60)
        let totalMin = Int(analyticsManager.getTimeSaved() / 60)
        let platforms = analyticsManager.getMostUsedPlatforms()
        let total = max(1, platforms.reduce(0) { $0 + $1.1 })
        var top = Array(platforms.prefix(4)).map { SharePlatform(name: $0.0.displayName, percent: Double($0.1) / Double(total) * 100.0) }

        var trend = buildTrend(days: 30)
        var badges = BadgesEngine.shared.unlockedBadges()

        // Apply module toggles by trimming data
        if !includePlatforms { top = [] }
        if !includeTrend { trend = [] }
        if !includeInsights { badges = [] }

        let appVersion = Bundle.main.infoDictionary?[("CFBundleShortVersionString")] as? String ?? "1.0"
        return ShareCardData(
            displayName: name,
            periodLabel: period,
            todaySavedMin: includeCoreStats ? todayMin : 0,
            totalSavedMin: includeCoreStats ? totalMin : 0,
            focusScore: includeCoreStats ? min(100, analyticsManager.getTotalSearches() * 2) : 0,
            efficiencyRate: includeCoreStats ? 0.74 : 0,
            topPlatforms: top,
            trend: trend,
            badges: badges,
            generatedAt: Date(),
            appVersion: appVersion
        )
    }

    private func buildTrend(days: Int) -> [Int] {
        let calendar = Calendar.current
        let endDate = Date()
        var result: [Int] = []
        for dayOffset in (0..<days).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: endDate) else { continue }
            let dateKey = DateFormatter.dayFormatter.string(from: date)
            let count = analyticsManager.analytics.dailySearches[dateKey] ?? 0
            result.append(count)
        }
        return result
    }
}


