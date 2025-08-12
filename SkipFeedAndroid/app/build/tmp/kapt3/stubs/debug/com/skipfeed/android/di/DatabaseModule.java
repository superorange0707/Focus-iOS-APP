package com.skipfeed.android.di;

@dagger.Module()
@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u00c7\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J\u0012\u0010\u0007\u001a\u00020\u00062\b\b\u0001\u0010\b\u001a\u00020\tH\u0007J\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\u0005\u001a\u00020\u0006H\u0007\u00a8\u0006\f"}, d2 = {"Lcom/skipfeed/android/di/DatabaseModule;", "", "()V", "provideSearchHistoryDao", "Lcom/skipfeed/android/data/database/SearchHistoryDao;", "database", "Lcom/skipfeed/android/data/database/SkipFeedDatabase;", "provideSkipFeedDatabase", "context", "Landroid/content/Context;", "provideUsageAnalyticsDao", "Lcom/skipfeed/android/data/database/UsageAnalyticsDao;", "app_debug"})
@dagger.hilt.InstallIn(value = {dagger.hilt.components.SingletonComponent.class})
public final class DatabaseModule {
    @org.jetbrains.annotations.NotNull()
    public static final com.skipfeed.android.di.DatabaseModule INSTANCE = null;
    
    private DatabaseModule() {
        super();
    }
    
    @dagger.Provides()
    @javax.inject.Singleton()
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.database.SkipFeedDatabase provideSkipFeedDatabase(@dagger.hilt.android.qualifiers.ApplicationContext()
    @org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        return null;
    }
    
    @dagger.Provides()
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.database.SearchHistoryDao provideSearchHistoryDao(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.database.SkipFeedDatabase database) {
        return null;
    }
    
    @dagger.Provides()
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.database.UsageAnalyticsDao provideUsageAnalyticsDao(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.database.SkipFeedDatabase database) {
        return null;
    }
}