package com.skipfeed.android.data.repository;

@javax.inject.Singleton()
@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00020\u0006H\u0086@\u00a2\u0006\u0002\u0010\u0007J\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\tJ\u0016\u0010\u000b\u001a\u00020\u00062\u0006\u0010\f\u001a\u00020\rH\u0086@\u00a2\u0006\u0002\u0010\u000eJ\u001e\u0010\u000f\u001a\u00020\u00062\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u0011H\u0086@\u00a2\u0006\u0002\u0010\u0012J\u000e\u0010\u0013\u001a\u00020\u0006H\u0086@\u00a2\u0006\u0002\u0010\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0014"}, d2 = {"Lcom/skipfeed/android/data/repository/UsageAnalyticsRepository;", "", "usageAnalyticsDao", "Lcom/skipfeed/android/data/database/UsageAnalyticsDao;", "(Lcom/skipfeed/android/data/database/UsageAnalyticsDao;)V", "clearAnalytics", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUsageAnalytics", "Lkotlinx/coroutines/flow/Flow;", "Lcom/skipfeed/android/data/model/UsageAnalytics;", "recordSearch", "platform", "Lcom/skipfeed/android/data/model/Platform;", "(Lcom/skipfeed/android/data/model/Platform;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "recordTimeSpent", "timeSpentMs", "", "(Lcom/skipfeed/android/data/model/Platform;JLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resetAnalytics", "app_release"})
public final class UsageAnalyticsRepository {
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.database.UsageAnalyticsDao usageAnalyticsDao = null;
    
    @javax.inject.Inject()
    public UsageAnalyticsRepository(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.database.UsageAnalyticsDao usageAnalyticsDao) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<com.skipfeed.android.data.model.UsageAnalytics> getUsageAnalytics() {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object recordSearch(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object recordTimeSpent(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.Platform platform, long timeSpentMs, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object resetAnalytics(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final java.lang.Object clearAnalytics(@org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super kotlin.Unit> $completion) {
        return null;
    }
}