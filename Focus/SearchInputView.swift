import SwiftUI

struct SearchInputView: View {
    @Binding var searchText: String
    let platform: Platform
    let onSearch: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.focusBlue.opacity(0.75))
                    .font(.title3)
                    .fontWeight(.medium)
                
                TextField(getPlaceholderText(), text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .focused($isTextFieldFocused)
                    .disabled(platform == .tiktok)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearch()
                    }
                    .onTapGesture {
                        if platform == .tiktok {
                            onSearch() // Open TikTok search page directly
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
            .background(Color.glassBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isTextFieldFocused ? Color.focusBlue.opacity(0.7) : Color.glassStroke,
                        lineWidth: isTextFieldFocused ? 2 : 1
                    )
            )
            .onTapGesture {
                // Always try to focus when tapping the search area
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
            .shadow(color: Color.shadowColor, radius: 10, x: 0, y: 5)
        }
    }
    
    private func getPlaceholderText() -> String {
        switch platform {
        case .tiktok:
            return "Tap to open TikTok search"
        default:
            return "Search \(platform.displayName)..."
        }
    }
}

#Preview {
    SearchInputView(
        searchText: .constant("iOS tutorial"),
        platform: .youtube,
        onSearch: {}
    )
    .padding()
    .background(
        LinearGradient(
            colors: [Color.gradientTop, Color.gradientMiddle, Color.gradientBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 