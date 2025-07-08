import SwiftUI

struct PlatformSelectorView: View {
    @Binding var selectedPlatform: Platform
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
            Text("Choose Platform")
                .font(.headline)
                    .fontWeight(.semibold)
                .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    ForEach(Platform.allCases, id: \.self) { platform in
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
                    .frame(width: 56, height: 56) // Slightly larger for better visibility
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
                    .fill(Color.white.opacity(isSelected ? 0.3 : 0.18)) // Slightly more opaque for better visibility
            )
            .background(
                isSelected ? Color.white.opacity(0.2) : Color.clear
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        isSelected ? platform.color : Color.white.opacity(0.25), // Slightly more visible borders
                        lineWidth: isSelected ? 2.5 : 1
                    )
            )
            .shadow(
                color: isSelected ? platform.color.opacity(0.2) : .black.opacity(0.08),
                radius: isSelected ? 16 : 8, // Enhanced shadows for better depth
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
            colors: [Color.white, Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 