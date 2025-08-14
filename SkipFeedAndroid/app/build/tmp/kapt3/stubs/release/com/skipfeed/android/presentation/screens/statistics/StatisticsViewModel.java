package com.skipfeed.android.presentation.screens.statistics;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\b\u0010\f\u001a\u00020\rH\u0002J\u0006\u0010\u000e\u001a\u00020\rR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\t\u00a2\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u000f"}, d2 = {"Lcom/skipfeed/android/presentation/screens/statistics/StatisticsViewModel;", "Landroidx/lifecycle/ViewModel;", "usageAnalyticsRepository", "Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "(Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;)V", "_uiState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/presentation/screens/statistics/StatisticsUiState;", "uiState", "Lkotlinx/coroutines/flow/StateFlow;", "getUiState", "()Lkotlinx/coroutines/flow/StateFlow;", "loadStatistics", "", "resetStatistics", "app_release"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class StatisticsViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.presentation.screens.statistics.StatisticsUiState> _uiState = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.statistics.StatisticsUiState> uiState = null;
    
    @javax.inject.Inject()
    public StatisticsViewModel(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.UsageAnalyticsRepository usageAnalyticsRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.statistics.StatisticsUiState> getUiState() {
        return null;
    }
    
    private final void loadStatistics() {
    }
    
    public final void resetStatistics() {
    }
}