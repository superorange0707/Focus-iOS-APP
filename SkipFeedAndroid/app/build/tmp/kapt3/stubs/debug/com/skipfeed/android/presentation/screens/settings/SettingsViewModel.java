package com.skipfeed.android.presentation.screens.settings;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u001f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u00a2\u0006\u0002\u0010\bJ\b\u0010\u0010\u001a\u00020\u0011H\u0002J\u0006\u0010\u0012\u001a\u00020\u0011J\u000e\u0010\u0013\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u0015J\u0014\u0010\u0016\u001a\u00020\u00112\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00190\u0018J\u000e\u0010\u001a\u001a\u00020\u00112\u0006\u0010\u001b\u001a\u00020\u001cJ\u000e\u0010\u001d\u001a\u00020\u00112\u0006\u0010\u001e\u001a\u00020\u001fR\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006 "}, d2 = {"Lcom/skipfeed/android/presentation/screens/settings/SettingsViewModel;", "Landroidx/lifecycle/ViewModel;", "userPreferencesRepository", "Lcom/skipfeed/android/data/repository/UserPreferencesRepository;", "searchRepository", "Lcom/skipfeed/android/data/repository/SearchRepository;", "usageAnalyticsRepository", "Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "(Lcom/skipfeed/android/data/repository/UserPreferencesRepository;Lcom/skipfeed/android/data/repository/SearchRepository;Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;)V", "_uiState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/presentation/screens/settings/SettingsUiState;", "uiState", "Lkotlinx/coroutines/flow/StateFlow;", "getUiState", "()Lkotlinx/coroutines/flow/StateFlow;", "loadSettings", "", "resetData", "toggleAutoDetectLanguage", "enabled", "", "updatePlatformOrder", "platforms", "", "Lcom/skipfeed/android/data/model/Platform;", "updatePreferredLanguage", "language", "", "updateSearchMode", "searchMode", "Lcom/skipfeed/android/data/model/SearchMode;", "app_debug"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class SettingsViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UserPreferencesRepository userPreferencesRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.SearchRepository searchRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.presentation.screens.settings.SettingsUiState> _uiState = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.settings.SettingsUiState> uiState = null;
    
    @javax.inject.Inject()
    public SettingsViewModel(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UserPreferencesRepository userPreferencesRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.settings.SettingsUiState> getUiState() {
        return null;
    }
    
    private final void loadSettings() {
    }
    
    public final void toggleAutoDetectLanguage(boolean enabled) {
    }
    
    public final void updateSearchMode(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchMode searchMode) {
    }
    
    public final void updatePreferredLanguage(@org.jetbrains.annotations.NotNull()
    java.lang.String language) {
    }
    
    public final void updatePlatformOrder(@org.jetbrains.annotations.NotNull()
    java.util.List<? extends com.skipfeed.android.data.model.Platform> platforms) {
    }
    
    public final void resetData() {
    }
}