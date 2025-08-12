package com.skipfeed.android.di

import android.content.Context
import androidx.room.Room
import com.skipfeed.android.data.database.SearchHistoryDao
import com.skipfeed.android.data.database.SkipFeedDatabase
import com.skipfeed.android.data.database.UsageAnalyticsDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideSkipFeedDatabase(@ApplicationContext context: Context): SkipFeedDatabase {
        return Room.databaseBuilder(
            context.applicationContext,
            SkipFeedDatabase::class.java,
            "skipfeed_database"
        )
        .fallbackToDestructiveMigration() // Allow database recreation if needed
        .build()
    }

    @Provides
    fun provideSearchHistoryDao(database: SkipFeedDatabase): SearchHistoryDao {
        return database.searchHistoryDao()
    }

    @Provides
    fun provideUsageAnalyticsDao(database: SkipFeedDatabase): UsageAnalyticsDao {
        return database.usageAnalyticsDao()
    }
}
