import SwiftUI

extension Color {
    // App brand colors that adapt to light/dark mode
    static let focusBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    
    // Background colors
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let backgroundTertiary = Color(.tertiarySystemBackground)
    
    // Glass effect colors that adapt to dark mode and blend with gradient
    static var glassBackground: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.systemBackground.withAlphaComponent(0.9)
            } else {
                // Light mode: subtle blue tint to match gradient
                return UIColor(red: 0.98, green: 0.99, blue: 1.0, alpha: 0.85)
            }
        })
        #else
        return Color(.systemBackground).opacity(0.9)
        #endif
    }
    
    static var glassStroke: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.systemGray5.withAlphaComponent(0.4)
            } else {
                // Light mode: very subtle blue-tinted stroke
                return UIColor(red: 0.9, green: 0.94, blue: 1.0, alpha: 0.5)
            }
        })
        #else
        return Color(.systemGray5).opacity(0.4)
        #endif
    }
    
    // Card backgrounds that adapt to dark mode and blend with gradient
    static var cardBackground: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.secondarySystemBackground.withAlphaComponent(0.6)
            } else {
                // Light mode: subtle blue tint to match gradient
                return UIColor(red: 0.97, green: 0.98, blue: 1.0, alpha: 0.6)
            }
        })
        #else
        return Color(.secondarySystemBackground).opacity(0.6)
        #endif
    }
    
    static var cardBackgroundSelected: Color {
        #if os(iOS)
        return Color(UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.tertiarySystemBackground.withAlphaComponent(0.8)
            } else {
                // Light mode: stronger blue tint for selection
                return UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 0.8)
            }
        })
        #else
        return Color(.tertiarySystemBackground).opacity(0.8)
        #endif
    }
    
    // Gradient colors for backgrounds
    static var gradientTop: Color {
        Color(.systemBackground)
    }
    
    static var gradientMiddle: Color {
        focusBlue.opacity(0.15)
    }
    
    static var gradientBottom: Color {
        Color(.systemBackground).opacity(0.9)
    }
    
    // Text colors for better visibility
    static var secondaryText: Color {
        Color(.secondaryLabel)
    }
    
    static var tertiaryText: Color {
        Color(.tertiaryLabel)
    }
    
    // Shadow colors
    static var shadowColor: Color {
        Color(.label).opacity(0.1)
    }
    
    static var selectedShadowColor: Color {
        focusBlue.opacity(0.2)
    }
}

// Environment-aware glassmorphism modifier
struct GlassMorphism: ViewModifier {
    var opacity: Double = 0.8
    var strokeOpacity: Double = 0.3
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.glassStroke.opacity(strokeOpacity), lineWidth: 1)
            )
    }
}

extension View {
    func glassMorphism(opacity: Double = 0.8, strokeOpacity: Double = 0.3) -> some View {
        modifier(GlassMorphism(opacity: opacity, strokeOpacity: strokeOpacity))
    }
} 