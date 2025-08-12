package com.skipfeed.android.data.api

import com.skipfeed.android.data.model.RedditResponse
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Query

interface RedditApiService {
    
    @GET("search.json")
    suspend fun searchPosts(
        @Query("q") query: String,
        @Query("sort") sort: String = "relevance",
        @Query("t") timeFilter: String = "all",
        @Query("limit") limit: Int = 25,
        @Query("after") after: String? = null,
        @Query("raw_json") rawJson: Int = 1
    ): Response<RedditResponse>
    
    @GET("r/{subreddit}/search.json")
    suspend fun searchInSubreddit(
        @retrofit2.http.Path("subreddit") subreddit: String,
        @Query("q") query: String,
        @Query("sort") sort: String = "relevance",
        @Query("t") timeFilter: String = "all",
        @Query("limit") limit: Int = 25,
        @Query("after") after: String? = null,
        @Query("restrict_sr") restrictSr: Int = 1,
        @Query("raw_json") rawJson: Int = 1
    ): Response<RedditResponse>
}
