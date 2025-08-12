package com.skipfeed.android.data.database

import androidx.room.*
import com.skipfeed.android.data.model.SearchHistoryItem
import kotlinx.coroutines.flow.Flow

@Dao
interface SearchHistoryDao {
    
    @Query("SELECT * FROM search_history ORDER BY timestamp DESC")
    fun getAllSearchHistory(): Flow<List<SearchHistoryItem>>
    
    @Query("SELECT * FROM search_history WHERE platform = :platform ORDER BY timestamp DESC")
    fun getSearchHistoryByPlatform(platform: String): Flow<List<SearchHistoryItem>>
    
    @Query("SELECT * FROM search_history ORDER BY timestamp DESC LIMIT :limit")
    suspend fun getRecentSearches(limit: Int = 10): List<SearchHistoryItem>
    
    @Query("SELECT DISTINCT query FROM search_history ORDER BY timestamp DESC LIMIT :limit")
    suspend fun getRecentQueries(limit: Int = 5): List<String>
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSearch(searchHistoryItem: SearchHistoryItem)
    
    @Delete
    suspend fun deleteSearch(searchHistoryItem: SearchHistoryItem)
    
    @Query("DELETE FROM search_history")
    suspend fun clearAllHistory()
    
    @Query("DELETE FROM search_history WHERE platform = :platform")
    suspend fun clearHistoryByPlatform(platform: String)
    
    @Query("DELETE FROM search_history WHERE timestamp < :beforeTimestamp")
    suspend fun deleteOldEntries(beforeTimestamp: Long)
}
