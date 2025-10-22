package com.skipfeed.android.presentation.viewmodel;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\b\u0007\u0018\u00002\u00020\u0001B\u0017\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u00a2\u0006\u0002\u0010\u0006J\b\u0010\u0013\u001a\u00020\u0014H\u0002R\u001a\u0010\u0007\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t0\bX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0014\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\f0\bX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u001d\u0010\r\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\t0\u000e\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\f0\u000e\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0015"}, d2 = {"Lcom/skipfeed/android/presentation/viewmodel/StatisticsViewModel;", "Landroidx/lifecycle/ViewModel;", "usageAnalyticsRepository", "Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "searchRepository", "Lcom/skipfeed/android/data/repository/SearchRepository;", "(Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;Lcom/skipfeed/android/data/repository/SearchRepository;)V", "_searchHistory", "Lkotlinx/coroutines/flow/MutableStateFlow;", "", "Lcom/skipfeed/android/data/model/SearchHistoryItem;", "_usageAnalytics", "Lcom/skipfeed/android/data/model/UsageAnalytics;", "searchHistory", "Lkotlinx/coroutines/flow/StateFlow;", "getSearchHistory", "()Lkotlinx/coroutines/flow/StateFlow;", "usageAnalytics", "getUsageAnalytics", "loadData", "", "app_debug"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class StatisticsViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.SearchRepository searchRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.data.model.UsageAnalytics> _usageAnalytics = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.data.model.UsageAnalytics> usageAnalytics = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> _searchHistory = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> searchHistory = null;
    
    @javax.inject.Inject()
    public StatisticsViewModel(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.data.model.UsageAnalytics> getUsageAnalytics() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> getSearchHistory() {
        return null;
    }
    
    private final void loadData() {
    }
}