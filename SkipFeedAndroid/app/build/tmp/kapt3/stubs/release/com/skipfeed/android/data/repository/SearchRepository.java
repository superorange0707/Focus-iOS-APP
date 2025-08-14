package com.skipfeed.android.data.repository;

@javax.inject.Singleton()
@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000n\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0007\u0018\u00002\u00020\u0001B\u001f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u00a2\u0006\u0002\u0010\bJ\u001e\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0086@\u00a2\u0006\u0002\u0010\u000fJ\u000e\u0010\u0010\u001a\u00020\nH\u0086@\u00a2\u0006\u0002\u0010\u0011J\u001e\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\f0\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u0015H\u0086@\u00a2\u0006\u0002\u0010\u0016J\u0012\u0010\u0017\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00190\u00130\u0018J\u001c\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\f0\u00132\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eJ\u0016\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eJX\u0010\u001d\u001a\u001c\u0012\u0018\u0012\u0016\u0012\n\u0012\b\u0012\u0004\u0012\u00020 0\u0013\u0012\u0006\u0012\u0004\u0018\u00010\f0\u001f0\u001e2\u0006\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010!\u001a\u00020\"2\b\b\u0002\u0010#\u001a\u00020$2\n\b\u0002\u0010%\u001a\u0004\u0018\u00010\fH\u0086@\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\u0004\b&\u0010\'R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0002\b!\n\u0005\b\u00a1\u001e0\u0001\u00a8\u0006("}, d2 = {"Lcom/skipfeed/android/data/repository/SearchRepository;", "", "redditApiService", "Lcom/skipfeed/android/data/api/RedditApiService;", "searchHistoryDao", "Lcom/skipfeed/android/data/database/SearchHistoryDao;", "context", "Landroid/content/Context;", "(Lcom/skipfeed/android/data/api/RedditApiService;Lcom/skipfeed/android/data/database/SearchHistoryDao;Landroid/content/Context;)V", "addToSearchHistory", "", "query", "", "platform", "Lcom/skipfeed/android/data/model/Platform;", "(Ljava/lang/String;Lcom/skipfeed/android/data/model/Platform;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearSearchHistory", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getRecentQueries", "", "limit", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getSearchHistory", "Lkotlinx/coroutines/flow/Flow;", "Lcom/skipfeed/android/data/model/SearchHistoryItem;", "getSuggestions", "performDirectSearch", "", "searchReddit", "Lkotlin/Result;", "Lkotlin/Pair;", "Lcom/skipfeed/android/data/model/RedditPost;", "sort", "Lcom/skipfeed/android/data/model/RedditSort;", "timeFilter", "Lcom/skipfeed/android/data/model/RedditTimeFilter;", "after", "searchReddit-yxL6bBk", "(Ljava/lang/String;Lcom/skipfeed/android/data/model/RedditSort;Lcom/skipfeed/android/data/model/RedditTimeFilter;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_release"})
public final class SearchRepository {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.api.RedditApiService redditApiService = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.database.SearchHistoryDao searchHistoryDao = null;
    @org.jetbrains.annotations.NotNull()
    private final android.content.Context context = null;
    
    @javax.inject.Inject()
    public SearchRepository(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.api.RedditApiService redditApiService, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.database.SearchHistoryDao searchHistoryDao, @org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> getSearchHistory() {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object addToSearchHistory(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object getRecentQueries(int limit, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.util.List<java.lang.String>> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object clearSearchHistory(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    public final boolean performDirectSearch(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform) {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<java.lang.String> getSuggestions(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform) {
        return null;
    }
}