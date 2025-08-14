package com.skipfeed.android.data.model;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0087\b\u0018\u00002\u00020\u0001Bo\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006\u0012\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006\u0012\u0014\b\u0002\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\n0\u0006\u0012\b\b\u0002\u0010\u000b\u001a\u00020\n\u0012\b\b\u0002\u0010\f\u001a\u00020\n\u00a2\u0006\u0002\u0010\rJ\t\u0010\u0018\u001a\u00020\u0003H\u00c6\u0003J\t\u0010\u0019\u001a\u00020\u0003H\u00c6\u0003J\u0015\u0010\u001a\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006H\u00c6\u0003J\u0015\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006H\u00c6\u0003J\u0015\u0010\u001c\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\n0\u0006H\u00c6\u0003J\t\u0010\u001d\u001a\u00020\nH\u00c6\u0003J\t\u0010\u001e\u001a\u00020\nH\u00c6\u0003Js\u0010\u001f\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u00062\u0014\b\u0002\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u00062\u0014\b\u0002\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\n0\u00062\b\b\u0002\u0010\u000b\u001a\u00020\n2\b\b\u0002\u0010\f\u001a\u00020\nH\u00c6\u0001J\u0013\u0010 \u001a\u00020!2\b\u0010\"\u001a\u0004\u0018\u00010\u0001H\u00d6\u0003J\u0018\u0010#\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00030%0$J\u0006\u0010\'\u001a\u00020\nJ\u0006\u0010(\u001a\u00020\nJ\u0006\u0010)\u001a\u00020\u0003J\t\u0010*\u001a\u00020\u0003H\u00d6\u0001J\t\u0010+\u001a\u00020\u0007H\u00d6\u0001R\u0011\u0010\f\u001a\u00020\n\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001d\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0016\u0010\u0002\u001a\u00020\u00038\u0006X\u0087\u0004\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\u000b\u001a\u00020\n\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000fR\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u00030\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0011R\u001d\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\n0\u0006\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0011R\u0011\u0010\u0004\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0013\u00a8\u0006,"}, d2 = {"Lcom/skipfeed/android/data/model/UsageAnalytics;", "", "id", "", "totalSearches", "searchesByPlatform", "", "", "dailySearches", "timeSpentOnPlatforms", "", "lastResetDate", "averageTimePerSearch", "(IILjava/util/Map;Ljava/util/Map;Ljava/util/Map;JJ)V", "getAverageTimePerSearch", "()J", "getDailySearches", "()Ljava/util/Map;", "getId", "()I", "getLastResetDate", "getSearchesByPlatform", "getTimeSpentOnPlatforms", "getTotalSearches", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "getMostUsedPlatforms", "", "Lkotlin/Pair;", "Lcom/skipfeed/android/data/model/Platform;", "getTimeSaved", "getTimeSavedToday", "getTodaysSearchCount", "hashCode", "toString", "app_release"})
@androidx.room.Entity(tableName = "usage_analytics")
public final class UsageAnalytics {
    @androidx.room.PrimaryKey()
    private final int id = 0;
    private final int totalSearches = 0;
    @org.jetbrains.annotations.NotNull()
    private final java.util.Map<java.lang.String, java.lang.Integer> searchesByPlatform = null;
    @org.jetbrains.annotations.NotNull()
    private final java.util.Map<java.lang.String, java.lang.Integer> dailySearches = null;
    @org.jetbrains.annotations.NotNull()
    private final java.util.Map<java.lang.String, java.lang.Long> timeSpentOnPlatforms = null;
    private final long lastResetDate = 0L;
    private final long averageTimePerSearch = 0L;
    
    public UsageAnalytics(int id, int totalSearches, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Integer> searchesByPlatform, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Integer> dailySearches, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Long> timeSpentOnPlatforms, long lastResetDate, long averageTimePerSearch) {
        super();
    }
    
    public final int getId() {
        return 0;
    }
    
    public final int getTotalSearches() {
        return 0;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Integer> getSearchesByPlatform() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Integer> getDailySearches() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Long> getTimeSpentOnPlatforms() {
        return null;
    }
    
    public final long getLastResetDate() {
        return 0L;
    }
    
    public final long getAverageTimePerSearch() {
        return 0L;
    }
    
    public final int getTodaysSearchCount() {
        return 0;
    }
    
    public final long getTimeSaved() {
        return 0L;
    }
    
    public final long getTimeSavedToday() {
        return 0L;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<kotlin.Pair<com.skipfeed.android.data.model.Platform, java.lang.Integer>> getMostUsedPlatforms() {
        return null;
    }
    
    public UsageAnalytics() {
        super();
    }
    
    public final int component1() {
        return 0;
    }
    
    public final int component2() {
        return 0;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Integer> component3() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Integer> component4() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.Map<java.lang.String, java.lang.Long> component5() {
        return null;
    }
    
    public final long component6() {
        return 0L;
    }
    
    public final long component7() {
        return 0L;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.model.UsageAnalytics copy(int id, int totalSearches, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Integer> searchesByPlatform, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Integer> dailySearches, @org.jetbrains.annotations.NotNull()
    java.util.Map<java.lang.String, java.lang.Long> timeSpentOnPlatforms, long lastResetDate, long averageTimePerSearch) {
        return null;
    }
    
    @java.lang.Override()
    public boolean equals(@org.jetbrains.annotations.Nullable()
    java.lang.Object other) {
        return false;
    }
    
    @java.lang.Override()
    public int hashCode() {
        return 0;
    }
    
    @java.lang.Override()
    @org.jetbrains.annotations.NotNull()
    public java.lang.String toString() {
        return null;
    }
}