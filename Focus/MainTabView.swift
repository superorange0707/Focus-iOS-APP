import SwiftUI

struct MainTabView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @State private var showOnboarding = false
    
    var body: some View {
        TabView {
            // Search Tab
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(0)
            
            // History Tab
            SearchHistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
                .tag(1)
            
            // Stats Tab
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(2)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.focusBlue)
        .onAppear {
            // Check if user has seen onboarding
            if !userPreferences.hasSeenOnboarding {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                userPreferences.setHasSeenOnboarding(true)
                showOnboarding = false
            }
        }
    }
}

#Preview {
    MainTabView()
}
