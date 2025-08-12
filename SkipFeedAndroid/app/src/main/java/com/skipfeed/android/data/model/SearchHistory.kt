package com.skipfeed.android.data.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity(tableName = "search_history")
data class SearchHistoryItem(
    @PrimaryKey val id: String = UUID.randomUUID().toString(),
    val query: String,
    val platform: String,
    val timestamp: Long = System.currentTimeMillis(),
    val resultCount: Int? = null
)
