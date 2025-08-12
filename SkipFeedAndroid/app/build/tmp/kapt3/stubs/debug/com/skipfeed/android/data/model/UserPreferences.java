package com.skipfeed.android.data.model;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B=\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\b\b\u0002\u0010\u000b\u001a\u00020\u0005\u00a2\u0006\u0002\u0010\fJ\t\u0010\u0016\u001a\u00020\u0003H\u00c6\u0003J\t\u0010\u0017\u001a\u00020\u0005H\u00c6\u0003J\u000f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\b0\u0007H\u00c6\u0003J\t\u0010\u0019\u001a\u00020\nH\u00c6\u0003J\t\u0010\u001a\u001a\u00020\u0005H\u00c6\u0003JA\u0010\u001b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\u0005H\u00c6\u0001J\u0013\u0010\u001c\u001a\u00020\u00052\b\u0010\u001d\u001a\u0004\u0018\u00010\u0001H\u00d6\u0003J\t\u0010\u001e\u001a\u00020\u001fH\u00d6\u0001J\t\u0010 \u001a\u00020\u0003H\u00d6\u0001R\u0011\u0010\u0004\u001a\u00020\u0005\u00a2\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0011\u0010\u000b\u001a\u00020\u0005\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000eR\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0011\u0010\t\u001a\u00020\n\u00a2\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015\u00a8\u0006!"}, d2 = {"Lcom/skipfeed/android/data/model/UserPreferences;", "", "preferredLanguage", "", "autoDetectLanguage", "", "platformOrder", "", "Lcom/skipfeed/android/data/model/Platform;", "searchMode", "Lcom/skipfeed/android/data/model/SearchMode;", "hasSeenOnboarding", "(Ljava/lang/String;ZLjava/util/List;Lcom/skipfeed/android/data/model/SearchMode;Z)V", "getAutoDetectLanguage", "()Z", "getHasSeenOnboarding", "getPlatformOrder", "()Ljava/util/List;", "getPreferredLanguage", "()Ljava/lang/String;", "getSearchMode", "()Lcom/skipfeed/android/data/model/SearchMode;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "", "toString", "app_debug"})
public final class UserPreferences {
    @org.jetbrains.annotations.NotNull()
    private final java.lang.String preferredLanguage = null;
    private final boolean autoDetectLanguage = false;
    @org.jetbrains.annotations.NotNull()
    private final java.util.List<com.skipfeed.android.data.model.Platform> platformOrder = null;
    @org.jetbrains.annotations.NotNull()
    private final com.skipfeed.android.data.model.SearchMode searchMode = null;
    private final boolean hasSeenOnboarding = false;
    
    public UserPreferences(@org.jetbrains.annotations.NotNull()
    java.lang.String preferredLanguage, boolean autoDetectLanguage, @org.jetbrains.annotations.NotNull()
    java.util.List<? extends com.skipfeed.android.data.model.Platform> platformOrder, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchMode searchMode, boolean hasSeenOnboarding) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getPreferredLanguage() {
        return null;
    }
    
    public final boolean getAutoDetectLanguage() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.skipfeed.android.data.model.Platform> getPlatformOrder() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.model.SearchMode getSearchMode() {
        return null;
    }
    
    public final boolean getHasSeenOnboarding() {
        return false;
    }
    
    public UserPreferences() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String component1() {
        return null;
    }
    
    public final boolean component2() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<com.skipfeed.android.data.model.Platform> component3() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.model.SearchMode component4() {
        return null;
    }
    
    public final boolean component5() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final com.skipfeed.android.data.model.UserPreferences copy(@org.jetbrains.annotations.NotNull()
    java.lang.String preferredLanguage, boolean autoDetectLanguage, @org.jetbrains.annotations.NotNull()
    java.util.List<? extends com.skipfeed.android.data.model.Platform> platformOrder, @org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchMode searchMode, boolean hasSeenOnboarding) {
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