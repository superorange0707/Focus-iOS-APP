package com.skipfeed.android.data.model;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0007\b\u0086\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B/\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\b\u00a2\u0006\u0002\u0010\tJ\u0018\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010\u0014\u001a\u00020\u00032\u0006\u0010\u0015\u001a\u00020\u0016J\u000e\u0010\u0017\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0003J\u000e\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u0015\u001a\u00020\u0016R\u0011\u0010\u0006\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0019\u0010\u0007\u001a\u00020\b\u00f8\u0001\u0000\u00f8\u0001\u0001\u00a2\u0006\n\n\u0002\u0010\u000e\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR\u0011\u0010\u0004\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000bR\u0011\u0010\u0005\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000bj\u0002\b\u001aj\u0002\b\u001bj\u0002\b\u001cj\u0002\b\u001dj\u0002\b\u001ej\u0002\b\u001f\u0082\u0002\u000b\n\u0005\b\u00a1\u001e0\u0001\n\u0002\b!\u00a8\u0006 "}, d2 = {"Lcom/skipfeed/android/data/model/Platform;", "", "displayName", "", "packageName", "searchUrl", "appScheme", "color", "Landroidx/compose/ui/graphics/Color;", "(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V", "getAppScheme", "()Ljava/lang/String;", "getColor-0d7_KjU", "()J", "J", "getDisplayName", "getPackageName", "getSearchUrl", "createSearchIntent", "Landroid/content/Intent;", "query", "context", "Landroid/content/Context;", "createWebIntent", "isAppInstalled", "", "REDDIT", "YOUTUBE", "X", "TIKTOK", "INSTAGRAM", "FACEBOOK", "app_release"})
public enum Platform {
    /*public static final*/ REDDIT /* = new REDDIT(null, null, null, null, 0L) */,
    /*public static final*/ YOUTUBE /* = new YOUTUBE(null, null, null, null, 0L) */,
    /*public static final*/ X /* = new X(null, null, null, null, 0L) */,
    /*public static final*/ TIKTOK /* = new TIKTOK(null, null, null, null, 0L) */,
    /*public static final*/ INSTAGRAM /* = new INSTAGRAM(null, null, null, null, 0L) */,
    /*public static final*/ FACEBOOK /* = new FACEBOOK(null, null, null, null, 0L) */;
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String displayName = null;
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String packageName = null;
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String searchUrl = null;
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String appScheme = null;
    private final long color = 0L;
    
    Platform(java.lang.String displayName, java.lang.String packageName, java.lang.String searchUrl, java.lang.String appScheme, long color) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getDisplayName() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getPackageName() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getSearchUrl() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getAppScheme() {
        return null;
    }
    
    public final boolean isAppInstalled(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        return false;
    }
    
    @org.jetbrains.annotations.Nullable()
    public final android.content.Intent createSearchIntent(@org.jetbrains.annotations.NotNull()
    java.lang.String query, @org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final android.content.Intent createWebIntent(@org.jetbrains.annotations.NotNull()
    java.lang.String query) {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public static kotlin.enums.EnumEntries<com.skipfeed.android.data.model.Platform> getEntries() {
        return null;
    }
}