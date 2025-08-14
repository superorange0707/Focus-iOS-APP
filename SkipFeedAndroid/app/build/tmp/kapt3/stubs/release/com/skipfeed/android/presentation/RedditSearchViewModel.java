package com.skipfeed.android.presentation;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\u0005\u00a2\u0006\u0002\u0010\u0002J\u0006\u0010\f\u001a\u00020\rJ\u0006\u0010\u000e\u001a\u00020\rJ\u000e\u0010\u000f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011J\u0006\u0010\u0012\u001a\u00020\rJ\u0016\u0010\u0013\u001a\u00020\r2\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0010\u001a\u00020\u0011J\u0016\u0010\u0016\u001a\u00020\r2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0010\u001a\u00020\u0011R\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\t\u00a2\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b\u00a8\u0006\u0019"}, d2 = {"Lcom/skipfeed/android/presentation/RedditSearchViewModel;", "Landroidx/lifecycle/ViewModel;", "()V", "_uiState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/presentation/RedditSearchUiState;", "redditApiService", "Lcom/skipfeed/android/data/RedditApiService;", "uiState", "Lkotlinx/coroutines/flow/StateFlow;", "getUiState", "()Lkotlinx/coroutines/flow/StateFlow;", "clearError", "", "loadMorePosts", "searchPosts", "query", "", "toggleFilters", "updateSort", "sort", "Lcom/skipfeed/android/data/RedditSort;", "updateTimeFilter", "timeFilter", "Lcom/skipfeed/android/data/RedditTimeFilter;", "app_release"})
public final class RedditSearchViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.RedditApiService redditApiService = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.presentation.RedditSearchUiState> _uiState = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.RedditSearchUiState> uiState = null;
    
    public RedditSearchViewModel() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.RedditSearchUiState> getUiState() {
        return null;
    }
    
    public final void searchPosts(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public final void loadMorePosts() {
    }
    
    public final void updateSort(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.RedditSort sort, @org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public final void updateTimeFilter(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.RedditTimeFilter timeFilter, @org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    public final void toggleFilters() {
    }
    
    public final void clearError() {
    }
}