package com.skipfeed.android.presentation.screens.search;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u001f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u00a2\u0006\u0002\u0010\bJ\u0006\u0010\u0010\u001a\u00020\u0011J\u0006\u0010\u0012\u001a\u00020\u0011J\b\u0010\u0013\u001a\u00020\u0011H\u0002J\u000e\u0010\u0014\u001a\u00020\u00112\u0006\u0010\u0015\u001a\u00020\u0016J\u000e\u0010\u0017\u001a\u00020\u00112\u0006\u0010\u0018\u001a\u00020\u0019J\u000e\u0010\u001a\u001a\u00020\u00112\u0006\u0010\u001b\u001a\u00020\u001cJ\u000e\u0010\u001d\u001a\u00020\u00112\u0006\u0010\u001e\u001a\u00020\u001fR\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006 "}, d2 = {"Lcom/skipfeed/android/presentation/screens/search/SearchViewModel;", "Landroidx/lifecycle/ViewModel;", "searchRepository", "Lcom/skipfeed/android/data/repository/SearchRepository;", "userPreferencesRepository", "Lcom/skipfeed/android/data/repository/UserPreferencesRepository;", "usageAnalyticsRepository", "Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "(Lcom/skipfeed/android/data/repository/SearchRepository;Lcom/skipfeed/android/data/repository/UserPreferencesRepository;Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;)V", "_uiState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/presentation/screens/search/SearchUiState;", "uiState", "Lkotlinx/coroutines/flow/StateFlow;", "getUiState", "()Lkotlinx/coroutines/flow/StateFlow;", "clearError", "", "clearRecentQueries", "loadRecentQueries", "performSearch", "context", "Landroid/content/Context;", "selectPlatform", "platform", "Lcom/skipfeed/android/data/model/Platform;", "updateSearchMode", "searchMode", "Lcom/skipfeed/android/data/model/SearchMode;", "updateSearchQuery", "query", "", "app_release"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class SearchViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.SearchRepository searchRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UserPreferencesRepository userPreferencesRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.presentation.screens.search.SearchUiState> _uiState = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.search.SearchUiState> uiState = null;
    
    @javax.inject.Inject()
    public SearchViewModel(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UserPreferencesRepository userPreferencesRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.search.SearchUiState> getUiState() {
        return null;
    }
    
    public final void updateSearchQuery(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public final void selectPlatform(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform) {
    }
    
    public final void updateSearchMode(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchMode searchMode) {
    }
    
    public final void performSearch(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    public final void clearRecentQueries() {
    }
    
    private final void loadRecentQueries() {
    }
    
    public final void clearError() {
    }
}