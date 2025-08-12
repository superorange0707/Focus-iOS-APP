package com.skipfeed.android.data.database;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0005\bg\u0018\u00002\u00020\u0001J\u000e\u0010\u0002\u001a\u00020\u0003H\u00a7@\u00a2\u0006\u0002\u0010\u0004J\u0016\u0010\u0005\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u0007H\u00a7@\u00a2\u0006\u0002\u0010\bJ\u0016\u0010\t\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\fJ\u0016\u0010\r\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\u000fH\u00a7@\u00a2\u0006\u0002\u0010\u0010J\u0014\u0010\u0011\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\u00130\u0012H\'J\u001e\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u00070\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u0016H\u00a7@\u00a2\u0006\u0002\u0010\u0017J\u001e\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u000f0\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u0016H\u00a7@\u00a2\u0006\u0002\u0010\u0017J\u001c\u0010\u0019\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\u00130\u00122\u0006\u0010\u0006\u001a\u00020\u0007H\'J\u0016\u0010\u001a\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\u000fH\u00a7@\u00a2\u0006\u0002\u0010\u0010\u00a8\u0006\u001b"}, d2 = {"Lcom/skipfeed/android/data/database/SearchHistoryDao;", "", "clearAllHistory", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearHistoryByPlatform", "platform", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteOldEntries", "beforeTimestamp", "", "(JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "deleteSearch", "searchHistoryItem", "Lcom/skipfeed/android/data/model/SearchHistoryItem;", "(Lcom/skipfeed/android/data/model/SearchHistoryItem;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getAllSearchHistory", "Lkotlinx/coroutines/flow/Flow;", "", "getRecentQueries", "limit", "", "(ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getRecentSearches", "getSearchHistoryByPlatform", "insertSearch", "app_debug"})
@androidx.room.Dao()
public abstract interface SearchHistoryDao {
    
    @androidx.room.Query(value = "SELECT * FROM search_history ORDER BY timestamp DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> getAllSearchHistory();
    
    @androidx.room.Query(value = "SELECT * FROM search_history WHERE platform = :platform ORDER BY timestamp DESC")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> getSearchHistoryByPlatform(@org.jetbrains.annotations.NotNull()
    java.lang.String platform);
    
    @androidx.room.Query(value = "SELECT * FROM search_history ORDER BY timestamp DESC LIMIT :limit")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object getRecentSearches(int limit, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.util.List<com.skipfeed.android.data.model.SearchHistoryItem>> $completion);
    
    @androidx.room.Query(value = "SELECT DISTINCT query FROM search_history ORDER BY timestamp DESC LIMIT :limit")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object getRecentQueries(int limit, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super java.util.List<java.lang.String>> $completion);
    
    @androidx.room.Insert(onConflict = 1)
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object insertSearch(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchHistoryItem searchHistoryItem, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Delete()
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object deleteSearch(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchHistoryItem searchHistoryItem, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM search_history")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object clearAllHistory(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM search_history WHERE platform = :platform")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object clearHistoryByPlatform(@org.jetbrains.annotations.NotNull()
    java.lang.String platform, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM search_history WHERE timestamp < :beforeTimestamp")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object deleteOldEntries(long beforeTimestamp, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 3, xi = 48)
    public static final class DefaultImpls {
    }
}