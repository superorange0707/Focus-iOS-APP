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

// MARK: - Achievement Card (Modern Design)
struct AchievementCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.99, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                // Header section
                VStack(spacing: 24) {
                    // Top section with logo and title
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SkipFeed")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Focus Achievement")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        // Achievement badge
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // User info
                    HStack {
                        Text(data.displayName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(data.periodLabel)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                // Main stats section
                VStack(spacing: 24) {
                    // Primary stats cards
                    HStack(spacing: 16) {
                        ModernStatCard(
                            value: "\(data.totalSavedMin)",
                            label: "Minutes Saved",
                            subtitle: "vs endless scrolling",
                            icon: "clock.badge.checkmark.fill",
                            color: Color(red: 0.2, green: 0.8, blue: 0.4),
                            gradient: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.7, blue: 0.3)]
                        )
                        
                        ModernStatCard(
                            value: "\(data.focusScore)",
                            label: "Focus Score",
                            subtitle: "out of 100",
                            icon: "target",
                            color: Color(red: 0.2, green: 0.6, blue: 1.0),
                            gradient: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.5, blue: 0.9)]
                        )
                    }
                    
                    // Achievements section
                    if !data.badges.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Achievements")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(data.badges.count) unlocked")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                                ForEach(data.badges.prefix(6), id: \.id) { badge in
                                    ModernBadgeView(badge: badge)
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal, 32)
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 16))
                        Text("Generated with SkipFeed")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(DateFormatter.shortDate.string(from: data.generatedAt))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(width: 1080, height: 1920)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Progress Card (Modern Design)
struct ProgressCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.98, blue: 0.96),
                    Color(red: 0.98, green: 1.0, blue: 0.98),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                // Header section
                VStack(spacing: 24) {
                    // Top section with logo and title
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SkipFeed")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Focus Progress")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        // Progress indicator
                        ZStack {
                            Circle()
                                .stroke(Color.green.opacity(0.2), lineWidth: 4)
                                .frame(width: 60, height: 60)
                            
                            Circle()
                                .trim(from: 0, to: min(Double(data.focusScore) / 100.0, 1.0))
                                .stroke(
                                    LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                )
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 1.0), value: data.focusScore)
                            
                            Text("\(data.focusScore)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // User info
                    HStack {
                        Text(data.displayName)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("•")
                            .foregroundColor(.secondary)
                        Text(data.periodLabel)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                // Main stats section
                VStack(spacing: 24) {
                    // Primary stats cards
                    VStack(spacing: 16) {
                        ModernStatCard(
                            value: "\(data.totalSavedMin)m",
                            label: "Time Saved",
                            subtitle: "vs endless scrolling",
                            icon: "clock.badge.checkmark.fill",
                            color: Color(red: 0.2, green: 0.8, blue: 0.4),
                            gradient: [Color(red: 0.2, green: 0.8, blue: 0.4), Color(red: 0.1, green: 0.7, blue: 0.3)]
                        )
                        
                        ModernStatCard(
                            value: "\(data.focusScore)",
                            label: "Focus Score",
                            subtitle: "out of 100",
                            icon: "target",
                            color: Color(red: 0.2, green: 0.6, blue: 1.0),
                            gradient: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.1, green: 0.5, blue: 0.9)]
                        )
                    }
                    
                    // Trend section
                    if !data.trend.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("7-Day Activity")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("Focus trend")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Modern trend chart
                            HStack(spacing: 6) {
                                ForEach(Array(data.trend.suffix(7).enumerated()), id: \.offset) { index, value in
                                    VStack(spacing: 8) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.blue.opacity(0.8), Color.blue],
                                                    startPoint: .bottom,
                                                    endPoint: .top
                                                )
                                            )
                                            .frame(width: 24, height: max(20, CGFloat(value) * 0.8))
                                            .animation(.easeInOut(duration: 0.6), value: value)
                                        
                                        Text("D\(index + 1)")
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(height: 100)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal, 32)
                    
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                        Text("Keep up the great work!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(DateFormatter.shortDate.string(from: data.generatedAt))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(width: 1080, height: 1920)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Challenge Card (Modern Design)
struct ChallengeCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.96, blue: 0.92),
                    Color(red: 1.0, green: 0.98, blue: 0.94),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                // Header section
                VStack(spacing: 24) {
                    // Top section with logo and title
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SkipFeed")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Focus Challenge")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        // Challenge badge
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.orange, Color.red],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "flame.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Challenge subtitle
                    HStack {
                        Text("Can you beat this?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                // Main challenge section
                VStack(spacing: 24) {
                    // Challenge stats
                    VStack(spacing: 16) {
                        ModernChallengeCard(
                            title: "Time Saved",
                            value: "\(data.totalSavedMin)m",
                            challenge: "Challenge: 120m this week",
                            icon: "clock.badge.checkmark.fill",
                            color: Color.orange,
                            gradient: [Color.orange, Color.red]
                        )
                        
                        ModernChallengeCard(
                            title: "Focus Score",
                            value: "\(data.focusScore)",
                            challenge: "Challenge: Reach 85+",
                            icon: "target",
                            color: Color.red,
                            gradient: [Color.red, Color.purple]
                        )
                    }
                    
                    // Top platforms section
                    if !data.topPlatforms.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Top Platforms")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("Usage breakdown")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(data.topPlatforms.prefix(3), id: \.name) { platform in
                                    HStack(spacing: 16) {
                                        Text(platform.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(platform.percent))%")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.orange)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Challenge call to action
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("🎯 Challenge Your Friends")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.orange)
                        
                        Text("Share this and see who can focus better!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 32)
                }
                
                // Footer
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal, 32)
                    
                    HStack {
                        Image(systemName: "gamecontroller.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16))
                        Text("Ready to compete?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(DateFormatter.shortDate.string(from: data.generatedAt))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(width: 1080, height: 1920)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Social Card (Modern Design)
struct SocialCardView: View {
    let data: ShareCardData
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.94, blue: 1.0),
                    Color(red: 0.98, green: 0.96, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 0) {
                // Header section
                VStack(spacing: 24) {
                    // Top section with logo and title
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SkipFeed")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Focus Community")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        // Community badge
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Community subtitle
                    HStack {
                        Text("Join the movement")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                // Main social section
                VStack(spacing: 24) {
                    // Social stats
                    VStack(spacing: 16) {
                        ModernSocialCard(
                            title: "Your Focus",
                            value: "\(data.focusScore)",
                            subtitle: "Community avg: 72",
                            icon: "person.2.fill",
                            color: Color.purple,
                            gradient: [Color.purple, Color.blue]
                        )
                        
                        ModernSocialCard(
                            title: "Time Saved",
                            value: "\(data.totalSavedMin)m",
                            subtitle: "This week",
                            icon: "clock.badge.checkmark.fill",
                            color: Color.pink,
                            gradient: [Color.pink, Color.red]
                        )
                    }
                    
                    // Achievements section
                    if !data.badges.isEmpty {
                        VStack(spacing: 16) {
                            HStack {
                                Text("Your Achievements")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(data.badges.count) earned")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(data.badges.prefix(5), id: \.id) { badge in
                                        ModernSocialBadge(badge: badge)
                                    }
                                }
                                .padding(.horizontal, 32)
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                // Social call to action
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        Text("🤝 Share Your Progress")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.purple)
                        
                        Text("Inspire others to focus better!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.purple.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 32)
                }
                
                // Footer
                VStack(spacing: 8) {
                    Divider()
                        .padding(.horizontal, 32)
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.purple)
                            .font(.system(size: 16))
                        Text("Build the community!")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(DateFormatter.shortDate.string(from: data.generatedAt))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                }
            }
        }
        .frame(width: 1080, height: 1920)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Modern Helper Views
struct ModernStatCard: View {
    let value: String
    let label: String
    let subtitle: String
    let icon: String
    let color: Color
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Icon and value
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                        .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            // Labels
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct ModernBadgeView: View {
    let badge: ShareBadge
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.orange, Color.red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 56, height: 56)
                    .shadow(color: .orange.opacity(0.3), radius: 6, x: 0, y: 3)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(badge.title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
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

struct ModernChallengeCard: View {
    let title: String
    let value: String
    let challenge: String
    let icon: String
    let color: Color
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 48, height: 48)
                        .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
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
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.1))
                )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}



struct ModernSocialCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let gradient: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
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
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct ModernSocialBadge: View {
    let badge: ShareBadge
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.purple, Color.pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 64, height: 64)
                    .shadow(color: .purple.opacity(0.3), radius: 6, x: 0, y: 3)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text(badge.title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}


