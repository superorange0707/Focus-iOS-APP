package com.skipfeed.android.data.database;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\bg\u0018\u00002\u00020\u0001J\u000e\u0010\u0002\u001a\u00020\u0003H\u00a7@\u00a2\u0006\u0002\u0010\u0004J\u0010\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00070\u0006H\'J\u0010\u0010\b\u001a\u0004\u0018\u00010\u0007H\u00a7@\u00a2\u0006\u0002\u0010\u0004J\u0016\u0010\t\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u0007H\u00a7@\u00a2\u0006\u0002\u0010\u000b\u00a8\u0006\f"}, d2 = {"Lcom/skipfeed/android/data/database/UsageAnalyticsDao;", "", "clearAnalytics", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUsageAnalytics", "Lkotlinx/coroutines/flow/Flow;", "Lcom/skipfeed/android/data/model/UsageAnalytics;", "getUsageAnalyticsOnce", "insertOrUpdateAnalytics", "analytics", "(Lcom/skipfeed/android/data/model/UsageAnalytics;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_debug"})
@androidx.room.Dao()
public abstract interface UsageAnalyticsDao {
    
    @androidx.room.Query(value = "SELECT * FROM usage_analytics WHERE id = 0")
    @org.jetbrains.annotations.NotNull()
    public abstract kotlinx.coroutines.flow.Flow<com.skipfeed.android.data.model.UsageAnalytics> getUsageAnalytics();
    
    @androidx.room.Query(value = "SELECT * FROM usage_analytics WHERE id = 0")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object getUsageAnalyticsOnce(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super com.skipfeed.android.data.model.UsageAnalytics> $completion);
    
    @androidx.room.Insert(onConflict = 1)
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object insertOrUpdateAnalytics(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.UsageAnalytics analytics, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
    
    @androidx.room.Query(value = "DELETE FROM usage_analytics")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object clearAnalytics(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion);
}