package com.skipfeed.android.data.repository;

@javax.inject.Singleton()
@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000Z\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u00a2\u0006\u0002\u0010\u0004J\b\u0010\u0010\u001a\u00020\u0007H\u0002J\b\u0010\u0011\u001a\u00020\u0007H\u0002J\u000e\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0015J\u0014\u0010\u0016\u001a\u00020\u00132\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00190\u0018J\u000e\u0010\u001a\u001a\u00020\u00132\u0006\u0010\u001b\u001a\u00020\u001cJ\u000e\u0010\u001d\u001a\u00020\u00132\u0006\u0010\u001e\u001a\u00020\u001fJ\u000e\u0010 \u001a\u00020\u00132\u0006\u0010!\u001a\u00020\u0007R\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004\u00a2\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00070\r\u00a2\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f\u00a8\u0006\""}, d2 = {"Lcom/skipfeed/android/data/repository/UserPreferencesRepository;", "", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "_userPreferences", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lcom/skipfeed/android/data/model/UserPreferences;", "gson", "Lcom/google/gson/Gson;", "sharedPreferences", "Landroid/content/SharedPreferences;", "userPreferences", "Lkotlinx/coroutines/flow/Flow;", "getUserPreferences", "()Lkotlinx/coroutines/flow/Flow;", "loadPreferences", "loadPreferencesWithFallback", "setHasSeenOnboarding", "", "hasSeenOnboarding", "", "setPlatformOrder", "platforms", "", "Lcom/skipfeed/android/data/model/Platform;", "setPreferredLanguage", "language", "", "setSearchMode", "searchMode", "Lcom/skipfeed/android/data/model/SearchMode;", "updatePreferences", "preferences", "app_release"})
public final class UserPreferencesRepository {
    @org.jetbrains.annotations.NotNull()
    private final android.content.Context context = null;
    @org.jetbrains.annotations.NotNull()
    private final android.content.SharedPreferences sharedPreferences = null;
    @org.jetbrains.annotations.NotNull()
    private final com.google.gson.Gson gson = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.MutableStateFlow<com.skipfeed.android.data.model.UserPreferences> _userPreferences = null;
    @org.jetbrains.annotations.NotNull()
    private final kotlinx.coroutines.flow.Flow<com.skipfeed.android.data.model.UserPreferences> userPreferences = null;
    
    @javax.inject.Inject()
    public UserPreferencesRepository(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final kotlinx.coroutines.flow.Flow<com.skipfeed.android.data.model.UserPreferences> getUserPreferences() {
        return null;
    }
    
    private final com.skipfeed.android.data.model.UserPreferences loadPreferencesWithFallback() {
        return null;
    }
    
    private final com.skipfeed.android.data.model.UserPreferences loadPreferences() {
        return null;
    }
    
    public final void updatePreferences(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.UserPreferences preferences) {
    }
    
    public final void setSearchMode(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.data.model.SearchMode searchMode) {
    }
    
    public final void setPlatformOrder(@org.jetbrains.annotations.NotNull()
    java.util.List<? extends com.skipfeed.android.data.model.Platform> platforms) {
    }
    
    public final void setHasSeenOnboarding(boolean hasSeenOnboarding) {
    }
    
    public final void setPreferredLanguage(@org.jetbrains.annotations.NotNull()
    java.lang.String language) {
    }
}