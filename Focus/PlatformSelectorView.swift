import SwiftUI

struct PlatformSelectorView: View {
    @Binding var selectedPlatform: Platform
    let platforms: [Platform]
    @StateObject private var localizationManager = LocalizationManager.shared

    init(selectedPlatform: Binding<Platform>, platforms: [Platform] = Platform.allCases) {
        self._selectedPlatform = selectedPlatform
        self.platforms = platforms
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(Color.secondaryText)
                    .font(.caption)
                
            Text(localizationManager.localizedString(.choosePlatform))
                .font(.headline)
                    .fontWeight(.semibold)
                .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(platforms, id: \.self) { platform in
                        PlatformCard(
                            platform: platform,
                            isSelected: selectedPlatform == platform
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedPlatform = platform
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct PlatformCard: View {
    let platform: Platform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                // Platform icon - enhanced quality and shadows
                Image(platform.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72, height: 56)
                    .scaleEffect(platform == .youtube ? 1.4 : 1.0)
                    .shadow(color: isSelected ? platform.color.opacity(0.3) : .black.opacity(0.12), radius: isSelected ? 12 : 3, x: 0, y: isSelected ? 5 : 2)
                
                // Platform name
                Text(platform.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? platform.color : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 90, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(isSelected ? Color.cardBackgroundSelected : Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isSelected ? platform.color : Color.glassStroke,
                        lineWidth: isSelected ? 2.5 : 1
                    )
            )
            .shadow(
                color: isSelected ? Color.selectedShadowColor : Color.shadowColor,
                radius: isSelected ? 16 : 8,
                x: 0,
                y: isSelected ? 8 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}



#Preview {
    VStack(spacing: 30) {
    PlatformSelectorView(selectedPlatform: .constant(.youtube))
        PlatformSelectorView(selectedPlatform: .constant(.x))
        PlatformSelectorView(selectedPlatform: .constant(.reddit))
    }
        .padding()
    .background(
        LinearGradient(
            colors: [Color.gradientTop, Color.gradientMiddle, Color.gradientBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 