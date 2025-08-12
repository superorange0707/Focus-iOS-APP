package com.skipfeed.android.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "usage_analytics")
data class UsageAnalytics(
    @PrimaryKey val id: Int = 0,
    val totalSearches: Int = 0,
    val searchesByPlatform: Map<String, Int> = emptyMap(),
    val dailySearches: Map<String, Int> = emptyMap(),
    val timeSpentOnPlatforms: Map<String, Long> = emptyMap(),
    val lastResetDate: Long = System.currentTimeMillis(),
    val averageTimePerSearch: Long = 30000L // 30 seconds in milliseconds
) {
    fun getTodaysSearchCount(): Int {
        val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
            .format(java.util.Date())
        return dailySearches[today] ?: 0
    }

    fun getTimeSaved(): Long {
        // Based on research: average time spent on social media before finding content
        val averageWastedTime: Long = 180000L // 3 minutes per search
        val timeSavedPerSearch = averageWastedTime - averageTimePerSearch
        return totalSearches * timeSavedPerSearch
    }

    fun getTimeSavedToday(): Long {
        val todaySearches = getTodaysSearchCount()
        val averageWastedTime: Long = 180000L
        val timeSavedPerSearch = averageWastedTime - averageTimePerSearch
        return todaySearches * timeSavedPerSearch
    }

    fun getMostUsedPlatforms(): List<Pair<Platform, Int>> {
        return searchesByPlatform.entries
            .mapNotNull { entry ->
                Platform.entries.find { it.name == entry.key }?.let { platform ->
                    platform to entry.value
                }
            }
            .sortedByDescending { it.second }
    }
}
