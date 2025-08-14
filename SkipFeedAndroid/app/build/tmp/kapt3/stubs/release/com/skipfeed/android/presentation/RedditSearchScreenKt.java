package com.skipfeed.android.presentation;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000D\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\u0006\n\u0000\u001a\u0010\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0007\u001a\u001e\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u00032\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\u00010\u0007H\u0007\u001a@\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u00020\u00010\u000e2\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00010\u000eH\u0007\u001a\b\u0010\u0010\u001a\u00020\u0001H\u0007\u001aH\u0010\u0011\u001a\u00020\u00012\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00140\u00132\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00162\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00010\u00072\u0012\u0010\u0019\u001a\u000e\u0012\u0004\u0012\u00020\u0014\u0012\u0004\u0012\u00020\u00010\u000eH\u0007\u001a\u001e\u0010\u001a\u001a\u00020\u00012\u0006\u0010\u001b\u001a\u00020\u00142\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\u00010\u0007H\u0007\u001a\u001e\u0010\u001d\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\u00010\u0007H\u0007\u001a\u0010\u0010\u001f\u001a\u00020\u00032\u0006\u0010 \u001a\u00020!H\u0002\u00a8\u0006\""}, d2 = {"EmptyView", "", "query", "", "ErrorView", "error", "onRetry", "Lkotlin/Function0;", "FilterBar", "selectedSort", "Lcom/skipfeed/android/data/RedditSort;", "selectedTimeFilter", "Lcom/skipfeed/android/data/RedditTimeFilter;", "onSortChange", "Lkotlin/Function1;", "onTimeFilterChange", "LoadingView", "PostsList", "posts", "", "Lcom/skipfeed/android/data/RedditPost;", "isLoadingMore", "", "hasMorePosts", "onLoadMore", "onPostClick", "RedditPostCard", "post", "onClick", "RedditSearchScreen", "onDismiss", "formatTime", "createdUtc", "", "app_release"})
public final class RedditSearchScreenKt {
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    public static final void RedditSearchScreen(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onDismiss) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void FilterBar(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.RedditSort selectedSort, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.RedditTimeFilter selectedTimeFilter, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super com.skipfeed.android.data.RedditSort, kotlin.Unit> onSortChange, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super com.skipfeed.android.data.RedditTimeFilter, kotlin.Unit> onTimeFilterChange) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void LoadingView() {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void ErrorView(@org.jetbrains.annotations.NotNull()
    java.lang.String error, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onRetry) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void EmptyView(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void PostsList(@org.jetbrains.annotations.NotNull()
    java.util.List<com.skipfeed.android.data.RedditPost> posts, boolean isLoadingMore, boolean hasMorePosts, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onLoadMore, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function1<? super com.skipfeed.android.data.RedditPost, kotlin.Unit> onPostClick) {
    }
    
    @androidx.compose.runtime.Composable()
    public static final void RedditPostCard(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.RedditPost post, @org.jetbrains.annotations.NotNull()
    kotlin.jvm.functions.Function0<kotlin.Unit> onClick) {
    }
    
    private static final java.lang.String formatTime(double createdUtc) {
        return null;
    }
}