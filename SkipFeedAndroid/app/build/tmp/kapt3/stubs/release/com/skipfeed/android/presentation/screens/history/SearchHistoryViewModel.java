package com.skipfeed.android.presentation.screens.history;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u0006\u0010\f\u001a\u00020\rJ\u0006\u0010\u000e\u001a\u00020\rJ\u000e\u0010\u000f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011J\u0006\u0010\u0012\u001a\u00020\rJ\b\u0010\u0013\u001a\u00020\rH\u0002J\u0006\u0010\u0014\u001a\u00020\rJ\u000e\u0010\u0015\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\u0017J\u0006\u0010\u0018\u001a\u00020\rR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\t\u00a2\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b\u00a8\u0006\u0019"}, d2 = {"Lcom/skipfeed/android/presentation/screens/history/SearchHistoryViewModel;", "Landroidx/lifecycle/ViewModel;", "searchRepository", "Lcom/skipfeed/android/data/repository/SearchRepository;", "(Lcom/skipfeed/android/data/repository/SearchRepository;)V", "_uiState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/presentation/screens/history/SearchHistoryUiState;", "uiState", "Lkotlinx/coroutines/flow/StateFlow;", "getUiState", "()Lkotlinx/coroutines/flow/StateFlow;", "clearHistory", "", "clearSelection", "deleteHistoryItem", "item", "Lcom/skipfeed/android/data/model/SearchHistoryItem;", "deleteSelectedItems", "loadSearchHistory", "selectAllItems", "toggleItemSelection", "itemId", "", "toggleSelectionMode", "app_release"})
@dagger.hilt.android.lifecycle.HiltViewModel()
public final class SearchHistoryViewModel extends androidx.lifecycle.ViewModel {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.repository.SearchRepository searchRepository = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.presentation.screens.history.SearchHistoryUiState> _uiState = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.history.SearchHistoryUiState> uiState = null;
    
    @javax.inject.Inject()
    public SearchHistoryViewModel(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.repository.SearchRepository searchRepository) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.StateFlow<com.skipfeed.android.presentation.screens.history.SearchHistoryUiState> getUiState() {
        return null;
    }
    
    private final void loadSearchHistory() {
    }
    
    public final void deleteHistoryItem(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchHistoryItem item) {
    }
    
    public final void clearHistory() {
    }
    
    public final void toggleSelectionMode() {
    }
    
    public final void toggleItemSelection(@org.jetbrains.annotations.NotNull()
    java.lang.String itemId) {
    }
    
    public final void selectAllItems() {
    }
    
    public final void clearSelection() {
    }
    
    public final void deleteSelectedItems() {
    }
}