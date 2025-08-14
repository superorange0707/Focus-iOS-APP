import SwiftUI
import UIKit

// MARK: - Modern iOS Fitness-style Share Cards

@available(iOS 16.0, *)
@MainActor
func renderAchievementCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = AchievementCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}

@available(iOS 16.0, *)
@MainActor
func renderProgressCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = ProgressCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}

@available(iOS 16.0, *)
@MainActor
func renderChallengeCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = ChallengeCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}

@available(iOS 16.0, *)
@MainActor
func renderSocialCardPNG(_ data: ShareCardData) -> UIImage? {
    let view = SocialCardView(data: data)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    return renderer.uiImage
}

// MARK: - Achievement Card (iOS Fitness-style)
struct AchievementCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header with achievement badge
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    
                    Text("Focus Achievement")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("\(data.displayName) • \(data.periodLabel)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Achievement stats
                VStack(spacing: 20) {
                    HStack(spacing: 32) {
                        AchievementStat(
                            value: "\(data.totalSavedMin)",
                            label: "Minutes Saved",
                            icon: "clock.badge.checkmark.fill",
                            color: .green
                        )
                        
                        AchievementStat(
                            value: "\(data.focusScore)",
                            label: "Focus Score",
                            icon: "target",
                            color: .blue
                        )
                    }
                    
                    if !data.badges.isEmpty {
                        VStack(spacing: 12) {
                            Text("Achievements Unlocked")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                                ForEach(data.badges.prefix(6), id: \.id) { badge in
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: badge.iconName)
                                                .font(.system(size: 24))
                                                .foregroundColor(.orange)
                                        }
                                        
                                        Text(badge.title)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("Generated with SkipFeed")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(32)
        }
        .frame(width: 1080, height: 1920)
        .background(Color(.systemBackground))
    }
}

// MARK: - Progress Card
struct ProgressCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Focus Progress")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("\(data.displayName) • \(data.periodLabel)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Progress stats
                VStack(spacing: 20) {
                    ProgressStat(
                        title: "Time Saved",
                        value: "\(data.totalSavedMin)m",
                        subtitle: "vs endless scrolling",
                        icon: "clock.badge.checkmark.fill",
                        color: .green
                    )
                    
                    ProgressStat(
                        title: "Focus Score",
                        value: "\(data.focusScore)",
                        subtitle: "out of 100",
                        icon: "target",
                        color: .blue
                    )
                    
                    if !data.trend.isEmpty {
                        VStack(spacing: 12) {
                            Text("7-Day Trend")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            // Simple trend visualization
                            HStack(spacing: 4) {
                                ForEach(Array(data.trend.suffix(7).enumerated()), id: \.offset) { index, value in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.blue.opacity(Double(value) / 100.0))
                                        .frame(height: 60)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.blue)
                    Text("Keep up the great work!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(32)
        }
        .frame(width: 1080, height: 1920)
        .background(Color(.systemBackground))
    }
}

// MARK: - Challenge Card
struct ChallengeCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.orange.opacity(0.1), Color.red.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "flame.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    
                    Text("Focus Challenge")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Can you beat this?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Challenge stats
                VStack(spacing: 20) {
                    ChallengeStat(
                        title: "Time Saved",
                        value: "\(data.totalSavedMin)m",
                        challenge: "Challenge: 120m this week",
                        icon: "clock.badge.checkmark.fill",
                        color: .orange
                    )
                    
                    ChallengeStat(
                        title: "Focus Score",
                        value: "\(data.focusScore)",
                        challenge: "Challenge: Reach 85+",
                        icon: "target",
                        color: .red
                    )
                    
                    if !data.topPlatforms.isEmpty {
                        VStack(spacing: 12) {
                            Text("Top Platforms")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 8) {
                                ForEach(data.topPlatforms.prefix(3), id: \.name) { platform in
                                    HStack {
                                        Text(platform.name)
                                            .font(.system(size: 16, weight: .medium))
                                        Spacer()
                                        Text("\(Int(platform.percent))%")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Challenge invitation
                VStack(spacing: 8) {
                    Text("🎯 Challenge Your Friends")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("Share this and see who can focus better!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(32)
        }
        .frame(width: 1080, height: 1920)
        .background(Color(.systemBackground))
    }
}

// MARK: - Social Card
struct SocialCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Focus Community")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Join the movement")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Social stats
                VStack(spacing: 20) {
                    SocialStat(
                        title: "Your Focus",
                        value: "\(data.focusScore)",
                        subtitle: "Community avg: 72",
                        icon: "person.2.fill",
                        color: .purple
                    )
                    
                    SocialStat(
                        title: "Time Saved",
                        value: "\(data.totalSavedMin)m",
                        subtitle: "This week",
                        icon: "clock.badge.checkmark.fill",
                        color: .pink
                    )
                    
                    if !data.badges.isEmpty {
                        VStack(spacing: 12) {
                            Text("Your Achievements")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(data.badges.prefix(5), id: \.id) { badge in
                                        VStack(spacing: 8) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.purple.opacity(0.2))
                                                    .frame(width: 60, height: 60)
                                                
                                                Image(systemName: badge.iconName)
                                                    .font(.system(size: 28))
                                                    .foregroundColor(.purple)
                                            }
                                            
                                            Text(badge.title)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Social call to action
                VStack(spacing: 8) {
                    Text("🤝 Share Your Progress")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.purple)
                    
                    Text("Inspire others to focus better!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(32)
        }
        .frame(width: 1080, height: 1920)
        .background(Color(.systemBackground))
    }
}

// MARK: - Helper Views
struct AchievementStat: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
    }
}

struct ProgressStat: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ChallengeStat: View {
    let title: String
    let value: String
    let challenge: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            Text(challenge)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SocialStat: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
