package com.skipfeed.android.data.database

import androidx.room.*
import com.skipfeed.android.data.model.UsageAnalytics
import kotlinx.coroutines.flow.Flow

@Dao
interface UsageAnalyticsDao {
    
    @Query("SELECT * FROM usage_analytics WHERE id = 0")
    fun getUsageAnalytics(): Flow<UsageAnalytics?>
    
    @Query("SELECT * FROM usage_analytics WHERE id = 0")
    suspend fun getUsageAnalyticsOnce(): UsageAnalytics?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdateAnalytics(analytics: UsageAnalytics)
    
    @Query("DELETE FROM usage_analytics")
    suspend fun clearAnalytics()
}
