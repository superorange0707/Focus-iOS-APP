package com.skipfeed.android.data.repository

import com.skipfeed.android.data.database.UsageAnalyticsDao
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.UsageAnalytics
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UsageAnalyticsRepository @Inject constructor(
    private val usageAnalyticsDao: UsageAnalyticsDao
) {
    
    fun getUsageAnalytics(): Flow<UsageAnalytics> {
        return usageAnalyticsDao.getUsageAnalytics().map { analytics ->
            analytics ?: UsageAnalytics()
        }
    }
    
    suspend fun recordSearch(platform: Platform) {
        val currentAnalytics = usageAnalyticsDao.getUsageAnalyticsOnce() ?: UsageAnalytics()
        
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())
        
        val updatedAnalytics = currentAnalytics.copy(
            totalSearches = currentAnalytics.totalSearches + 1,
            searchesByPlatform = currentAnalytics.searchesByPlatform.toMutableMap().apply {
                put(platform.name, (get(platform.name) ?: 0) + 1)
            },
            dailySearches = currentAnalytics.dailySearches.toMutableMap().apply {
                put(today, (get(today) ?: 0) + 1)
            }
        )
        
        usageAnalyticsDao.insertOrUpdateAnalytics(updatedAnalytics)
    }
    
    suspend fun recordTimeSpent(platform: Platform, timeSpentMs: Long) {
        val currentAnalytics = usageAnalyticsDao.getUsageAnalyticsOnce() ?: UsageAnalytics()
        
        val updatedAnalytics = currentAnalytics.copy(
            timeSpentOnPlatforms = currentAnalytics.timeSpentOnPlatforms.toMutableMap().apply {
                put(platform.name, (get(platform.name) ?: 0L) + timeSpentMs)
            }
        )
        
        usageAnalyticsDao.insertOrUpdateAnalytics(updatedAnalytics)
    }
    
    suspend fun resetAnalytics() {
        val resetAnalytics = UsageAnalytics(lastResetDate = System.currentTimeMillis())
        usageAnalyticsDao.insertOrUpdateAnalytics(resetAnalytics)
    }
    
    suspend fun clearAnalytics() {
        usageAnalyticsDao.clearAnalytics()
    }
}
