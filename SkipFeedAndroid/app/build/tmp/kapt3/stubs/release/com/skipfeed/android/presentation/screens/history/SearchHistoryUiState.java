package com.skipfeed.android.presentation.screens.history;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\"\n\u0002\b\u0011\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001BE\u0012\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\b\u0002\u0010\t\u001a\u00020\u0006\u0012\u000e\b\u0002\u0010\n\u001a\b\u0012\u0004\u0012\u00020\b0\u000b\u00a2\u0006\u0002\u0010\fJ\u000f\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003H\u00c6\u0003J\t\u0010\u0015\u001a\u00020\u0006H\u00c6\u0003J\u000b\u0010\u0016\u001a\u0004\u0018\u00010\bH\u00c6\u0003J\t\u0010\u0017\u001a\u00020\u0006H\u00c6\u0003J\u000f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\b0\u000bH\u00c6\u0003JI\u0010\u0019\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2\b\b\u0002\u0010\t\u001a\u00020\u00062\u000e\b\u0002\u0010\n\u001a\b\u0012\u0004\u0012\u00020\b0\u000bH\u00c6\u0001J\u0013\u0010\u001a\u001a\u00020\u00062\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001H\u00d6\u0003J\t\u0010\u001c\u001a\u00020\u001dH\u00d6\u0001J\t\u0010\u001e\u001a\u00020\bH\u00d6\u0001R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\b\u00a2\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u0005\u001a\u00020\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u000fR\u0011\u0010\t\u001a\u00020\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\t\u0010\u000fR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0017\u0010\n\u001a\b\u0012\u0004\u0012\u00020\b0\u000b\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013\u00a8\u0006\u001f"}, d2 = {"Lcom/skipfeed/android/presentation/screens/history/SearchHistoryUiState;", "", "searchHistory", "", "Lcom/skipfeed/android/data/model/SearchHistoryItem;", "isLoading", "", "error", "", "isSelectionMode", "selectedItems", "", "(Ljava/util/List;ZLjava/lang/String;ZLjava/util/Set;)V", "getError", "()Ljava/lang/String;", "()Z", "getSearchHistory", "()Ljava/util/List;", "getSelectedItems", "()Ljava/util/Set;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "", "toString", "app_release"})
public final class SearchHistoryUiState {
    @org.jetbrains.annotations.NotNull()
    private final java.util.List<com.skipfeed.android.data.model.SearchHistoryItem> searchHistory = null;
    private final boolean isLoading = false;
    @org.jetbrains.annotations.Nullable()
    private final java.lang.String error = null;
    private final boolean isSelectionMode = false;
    @org.jetbrains.annotations.NotNull()
    private final java.util.Set<java.lang.String> selectedItems = null;
    
    public SearchHistoryUiState(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.data.model.SearchHistoryItem> searchHistory, boolean isLoading, @org.jetbrains.annotations.Nullable()
    java.lang.String error, boolean isSelectionMode, @org.jetbrains.annotations.NotNull()
    java.util.Set<java.lang.String> selectedItems) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.skipfeed.android.data.model.SearchHistoryItem> getSearchHistory() {
        return null;
    }
    
    public final boolean isLoading() {
        return false;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String getError() {
        return null;
    }
    
    public final boolean isSelectionMode() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Set<java.lang.String> getSelectedItems() {
        return null;
    }
    
    public SearchHistoryUiState() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.skipfeed.android.data.model.SearchHistoryItem> component1() {
        return null;
    }
    
    public final boolean component2() {
        return false;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.String component3() {
        return null;
    }
    
    public final boolean component4() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Set<java.lang.String> component5() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.presentation.screens.history.SearchHistoryUiState copy(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.data.model.SearchHistoryItem> searchHistory, boolean isLoading, @org.jetbrains.annotations.Nullable()
    java.lang.String error, boolean isSelectionMode, @org.jetbrains.annotations.NotNull()
    java.util.Set<java.lang.String> selectedItems) {
        return null;
    }
    
    @java.lang.Override()
    public boolean equals(@org.jetbrains.annotations.Nullable()
    java.lang.Object other) {
        return false;
    }
    
    @java.lang.Override()
    public int hashCode() {
        return 0;
    }
    
    @java.lang.Override()
    @org.jetbrains.annotations.NotNull()
    public java.lang.String toString() {
        return null;
    }
}