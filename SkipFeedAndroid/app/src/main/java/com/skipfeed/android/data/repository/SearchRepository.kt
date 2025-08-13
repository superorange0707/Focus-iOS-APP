package com.skipfeed.android.data.repository

import android.content.Context
import android.content.Intent
import com.skipfeed.android.data.api.RedditApiService
import com.skipfeed.android.data.database.SearchHistoryDao
import com.skipfeed.android.data.model.Platform
import com.skipfeed.android.data.model.RedditPost
import com.skipfeed.android.data.model.RedditSort
import com.skipfeed.android.data.model.RedditTimeFilter
import com.skipfeed.android.data.model.SearchHistoryItem
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SearchRepository @Inject constructor(
    private val redditApiService: RedditApiService,
    private val searchHistoryDao: SearchHistoryDao,
    private val context: Context
) {
    
    fun getSearchHistory(): Flow<List<SearchHistoryItem>> {
        return searchHistoryDao.getAllSearchHistory()
    }
    
    suspend fun addToSearchHistory(query: String, platform: Platform) {
        try {
            android.util.Log.d("SearchRepository", "Creating SearchHistoryItem: query='$query', platform='${platform.name}'")
            val searchHistoryItem = SearchHistoryItem(
                query = query,
                platform = platform.name,
                timestamp = System.currentTimeMillis()
            )
            android.util.Log.d("SearchRepository", "Inserting into database: $searchHistoryItem")
            searchHistoryDao.insertSearch(searchHistoryItem)
            android.util.Log.d("SearchRepository", "Successfully inserted search history item")
        } catch (e: Exception) {
            android.util.Log.e("SearchRepository", "Failed to add search to history", e)
            throw e
        }
    }
    
    suspend fun getRecentQueries(limit: Int = 5): List<String> {
        return searchHistoryDao.getRecentQueries(limit)
    }
    
    suspend fun clearSearchHistory() {
        searchHistoryDao.clearAllHistory()
    }
    
    suspend fun searchReddit(
        query: String,
        sort: RedditSort = RedditSort.RELEVANCE,
        timeFilter: RedditTimeFilter = RedditTimeFilter.ALL,
        after: String? = null
    ): Result<Pair<List<RedditPost>, String?>> {
        return try {
            val response = redditApiService.searchPosts(
                query = query,
                sort = sort.value,
                timeFilter = timeFilter.value,
                after = after
            )
            
            if (response.isSuccessful) {
                val redditResponse = response.body()!!
                val posts = redditResponse.data.children.map { it.data }
                val afterToken = redditResponse.data.after
                Result.success(Pair(posts, afterToken))
            } else {
                Result.failure(Exception("Reddit API error: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
    
    fun performDirectSearch(query: String, platform: Platform): Boolean {
        return try {
            val intent = if (platform == Platform.TIKTOK && query.isEmpty()) {
                // Special handling for TikTok - open to search page
                platform.createWebIntent("")
            } else {
                platform.createSearchIntent(query, context)
            }
            
            intent?.let {
                context.startActivity(it)
                true
            } ?: false
        } catch (e: Exception) {
            false
        }
    }
    
    fun getSuggestions(query: String, platform: Platform): List<String> {
        return when (platform) {
            Platform.YOUTUBE -> listOf(
                "$query tutorial",
                "$query review",
                "$query 2024",
                "how to $query"
            )
            Platform.REDDIT -> listOf(
                "r/$query",
                "$query reddit",
                "$query discussion",
                "$query community"
            )
            Platform.INSTAGRAM -> listOf(
                query,
                "$query photos",
                "$query reels",
                "$query stories"
            )
            Platform.FACEBOOK -> listOf(
                "$query facebook",
                "$query group",
                "$query page",
                "$query event"
            )
            Platform.X -> listOf(
                "#$query",
                "$query twitter",
                "$query news",
                "$query trending"
            )
            Platform.TIKTOK -> listOf(
                "#$query",
                "$query challenge",
                "$query dance",
                "$query trending"
            )
        }
    }
}
