package com.skipfeed.android.data.model

import com.google.gson.annotations.SerializedName

data class RedditResponse(
    val data: RedditListing
)

data class RedditListing(
    val children: List<RedditChild>,
    val after: String?
)

data class RedditChild(
    val data: RedditPost
)

data class RedditPost(
    val id: String,
    val title: String,
    val author: String,
    val subreddit: String,
    val score: Int,
    @SerializedName("num_comments") val numComments: Int,
    @SerializedName("created_utc") val created: Double,
    val url: String,
    val permalink: String,
    val selftext: String?,
    val thumbnail: String?,
    val preview: RedditPreview?,
    @SerializedName("is_video") val isVideo: Boolean
) {
    val redditUrl: String
        get() = "https://www.reddit.com$permalink"

    val createdDate: Long
        get() = (created * 1000).toLong()

    val thumbnailUrl: String?
        get() = if (thumbnail != null && 
                   thumbnail != "self" && 
                   thumbnail != "default" && 
                   thumbnail != "nsfw" && 
                   thumbnail != "spoiler" && 
                   thumbnail.startsWith("http")) {
            thumbnail
        } else null

    val previewImageUrl: String?
        get() = preview?.images?.firstOrNull()?.source?.url?.replace("&amp;", "&")
}

data class RedditPreview(
    val images: List<RedditImage>
)

data class RedditImage(
    val source: RedditImageSource
)

data class RedditImageSource(
    val url: String,
    val width: Int,
    val height: Int
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
