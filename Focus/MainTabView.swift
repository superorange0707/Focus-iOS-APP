import SwiftUI

struct MainTabView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var userPreferences = UserPreferencesManager.shared
    @State private var showOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(0)
            
            SearchHistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .tabViewStyle(DefaultTabViewStyle())
        .accentColor(.focusBlue)
        .environment(\.horizontalSizeClass, .compact)
        .onAppear {
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
