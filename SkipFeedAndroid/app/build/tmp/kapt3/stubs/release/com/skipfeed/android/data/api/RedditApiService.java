package com.skipfeed.android.data.api;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0007\bf\u0018\u00002\u00020\u0001Jf\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0001\u0010\u0005\u001a\u00020\u00062\b\b\u0001\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u00062\b\b\u0003\u0010\t\u001a\u00020\u00062\b\b\u0003\u0010\n\u001a\u00020\u000b2\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\u00062\b\b\u0003\u0010\r\u001a\u00020\u000b2\b\b\u0003\u0010\u000e\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\u000fJR\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0001\u0010\u0007\u001a\u00020\u00062\b\b\u0003\u0010\b\u001a\u00020\u00062\b\b\u0003\u0010\t\u001a\u00020\u00062\b\b\u0003\u0010\n\u001a\u00020\u000b2\n\b\u0003\u0010\f\u001a\u0004\u0018\u00010\u00062\b\b\u0003\u0010\u000e\u001a\u00020\u000bH\u00a7@\u00a2\u0006\u0002\u0010\u0011\u00a8\u0006\u0012"}, d2 = {"Lcom/skipfeed/android/data/api/RedditApiService;", "", "searchInSubreddit", "Lretrofit2/Response;", "Lcom/skipfeed/android/data/model/RedditResponse;", "subreddit", "", "query", "sort", "timeFilter", "limit", "", "after", "restrictSr", "rawJson", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;IILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "searchPosts", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;ILkotlin/coroutines/Continuation;)Ljava/lang/Object;", "app_release"})
public abstract interface RedditApiService {
    
    @retrofit2.http.GET(value = "search.json")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object searchPosts(@retrofit2.http.Query(value = "q")
    @org.jetbrains.annotations.NotNull()
    java.lang.String query, @retrofit2.http.Query(value = "sort")
    @org.jetbrains.annotations.NotNull()
    java.lang.String sort, @retrofit2.http.Query(value = "t")
    @org.jetbrains.annotations.NotNull()
    java.lang.String timeFilter, @retrofit2.http.Query(value = "limit")
    int limit, @retrofit2.http.Query(value = "after")
    @org.jetbrains.annotations.Nullable()
    java.lang.String after, @retrofit2.http.Query(value = "raw_json")
    int rawJson, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super retrofit2.Response<com.skipfeed.android.data.model.RedditResponse>> $completion);
    
    @retrofit2.http.GET(value = "r/{subreddit}/search.json")
    @org.jetbrains.annotations.Nullable()
    public abstract java.lang.Object searchInSubreddit(@retrofit2.http.Path(value = "subreddit")
    @org.jetbrains.annotations.NotNull()
    java.lang.String subreddit, @retrofit2.http.Query(value = "q")
    @org.jetbrains.annotations.NotNull()
    java.lang.String query, @retrofit2.http.Query(value = "sort")
    @org.jetbrains.annotations.NotNull()
    java.lang.String sort, @retrofit2.http.Query(value = "t")
    @org.jetbrains.annotations.NotNull()
    java.lang.String timeFilter, @retrofit2.http.Query(value = "limit")
    int limit, @retrofit2.http.Query(value = "after")
    @org.jetbrains.annotations.Nullable()
    java.lang.String after, @retrofit2.http.Query(value = "restrict_sr")
    int restrictSr, @retrofit2.http.Query(value = "raw_json")
    int rawJson, @org.jetbrains.annotations.NotNull()
    kotlin.coroutines.Continuation<? super retrofit2.Response<com.skipfeed.android.data.model.RedditResponse>> $completion);
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 3, xi = 48)
    public static final class DefaultImpls {
    }
}