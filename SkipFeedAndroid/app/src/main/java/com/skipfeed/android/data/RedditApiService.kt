package com.skipfeed.android.data

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder

@Serializable
data class RedditResponse(
    val data: RedditListing
)

@Serializable
data class RedditListing(
    val children: List<RedditChild>,
    val after: String? = null
)

@Serializable
data class RedditChild(
    val data: RedditPost
)

@Serializable
data class RedditPost(
    val id: String,
    val title: String,
    val author: String,
    val subreddit: String,
    val score: Int,
    val num_comments: Int,
    val created_utc: Double,
    val url: String,
    val permalink: String,
    val selftext: String? = null,
    val thumbnail: String? = null,
    val preview: RedditPreview? = null,
    val is_video: Boolean = false
) {
    val redditUrl: String
        get() = "https://www.reddit.com$permalink"
    
    val previewImageUrl: String?
        get() = preview?.images?.firstOrNull()?.source?.url?.replace("&amp;", "&")
    
    val thumbnailUrl: String?
        get() = if (thumbnail != null && thumbnail != "self" && thumbnail != "default") thumbnail else null
}

@Serializable
data class RedditPreview(
    val images: List<RedditImage>? = null
)

@Serializable
data class RedditImage(
    val source: RedditImageSource
)

@Serializable
data class RedditImageSource(
    val url: String
)

enum class RedditSort(val value: String, val displayName: String) {
    RELEVANCE("relevance", "Relevance"),
    HOT("hot", "Hot"),
    TOP("top", "Top"),
    NEW("new", "New"),
    COMMENTS("comments", "Comments")
}

enum class RedditTimeFilter(val value: String, val displayName: String) {
    ALL("all", "All Time"),
    YEAR("year", "Past Year"),
    MONTH("month", "Past Month"),
    WEEK("week", "Past Week"),
    DAY("day", "Past Day"),
    HOUR("hour", "Past Hour")
}

class RedditApiService {
    private val json = Json { 
        ignoreUnknownKeys = true
        coerceInputValues = true
    }
    
    suspend fun searchPosts(
        query: String,
        sort: RedditSort = RedditSort.RELEVANCE,
        timeFilter: RedditTimeFilter = RedditTimeFilter.ALL,
        after: String? = null,
        limit: Int = 25
    ): Result<Pair<List<RedditPost>, String?>> = withContext(Dispatchers.IO) {
        try {
            val encodedQuery = URLEncoder.encode(query, "UTF-8")
            val url = buildString {
                append("https://www.reddit.com/search.json")
                append("?q=$encodedQuery")
                append("&sort=${sort.value}")
                append("&t=${timeFilter.value}")
                append("&limit=$limit")
                append("&raw_json=1")
                if (after != null) {
                    append("&after=$after")
                }
            }
            
            val connection = URL(url).openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.setRequestProperty("User-Agent", "SkipFeed Android App")
            
            if (connection.responseCode == 200) {
                val response = connection.inputStream.bufferedReader().use { it.readText() }
                val redditResponse = json.decodeFromString<RedditResponse>(response)
                val posts = redditResponse.data.children.map { it.data }
                val afterToken = redditResponse.data.after
                
                Result.success(Pair(posts, afterToken))
            } else {
                Result.failure(Exception("HTTP ${connection.responseCode}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
