package com.skipfeed.android.data.database

import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.skipfeed.android.data.model.SearchHistoryItem
import com.skipfeed.android.data.model.UsageAnalytics

@Database(
    entities = [SearchHistoryItem::class, UsageAnalytics::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class SkipFeedDatabase : RoomDatabase() {
    
    abstract fun searchHistoryDao(): SearchHistoryDao
    abstract fun usageAnalyticsDao(): UsageAnalyticsDao

    companion object {
        @Volatile
        private var INSTANCE: SkipFeedDatabase? = null

        fun getDatabase(context: Context): SkipFeedDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    SkipFeedDatabase::class.java,
                    "skipfeed_database"
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}

class Converters {
    @TypeConverter
    fun fromStringMap(value: Map<String, Int>): String {
        return Gson().toJson(value)
    }

    @TypeConverter
    fun toStringMap(value: String): Map<String, Int> {
        return try {
            Gson().fromJson<Map<String, Int>>(
                value,
                object : TypeToken<Map<String, Int>>() {}.type
            ) ?: emptyMap()
        } catch (e: Exception) {
            emptyMap()
        }
    }

    @TypeConverter
    fun fromStringLongMap(value: Map<String, Long>): String {
        return Gson().toJson(value)
    }

    @TypeConverter
    fun toStringLongMap(value: String): Map<String, Long> {
        return try {
            Gson().fromJson<Map<String, Long>>(
                value,
                object : TypeToken<Map<String, Long>>() {}.type
            ) ?: emptyMap()
        } catch (e: Exception) {
            emptyMap()
        }
    }
}
