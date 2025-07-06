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
                    .foregroundColor(Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.7))
                    .font(.title3)
                    .fontWeight(.medium)
                
                TextField("Search \(platform.displayName)...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        onSearch()
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
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isTextFieldFocused ? Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.7) : Color.white.opacity(0.18),
                        lineWidth: isTextFieldFocused ? 2 : 1
                    )
            )
            .shadow(color: Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.08), radius: 10, x: 0, y: 5)
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
            colors: [Color.white, Color(red: 0.0, green: 0.48, blue: 1.0).opacity(0.12)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 