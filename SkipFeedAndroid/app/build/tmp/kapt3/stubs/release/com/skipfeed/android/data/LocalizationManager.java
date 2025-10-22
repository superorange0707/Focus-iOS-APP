package com.skipfeed.android.data;

@kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\b\n\u0002\u0010$\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\u0018\u0000 \u001e2\u00020\u0001:\u0001\u001eB\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002J\u0018\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0004H\u0002J\u0006\u0010\u0013\u001a\u00020\u0004J\u000e\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u0004J\u0018\u0010\u0016\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u00180\u0017J\u0006\u0010\u0019\u001a\u00020\u0004J\u000e\u0010\u001a\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u0011J\u0006\u0010\u001b\u001a\u00020\u001cJ\u0016\u0010\u001d\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0004R+\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u00048F@BX\u0086\u008e\u0002\u00a2\u0006\u0012\n\u0004\b\n\u0010\u000b\u001a\u0004\b\u0006\u0010\u0007\"\u0004\b\b\u0010\tR\u001a\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\rX\u0082\u0004\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u001f"}, d2 = {"Lcom/skipfeed/android/data/LocalizationManager;", "", "()V", "<set-?>", "", "currentLanguage", "getCurrentLanguage", "()Ljava/lang/String;", "setCurrentLanguage", "(Ljava/lang/String;)V", "currentLanguage$delegate", "Landroidx/compose/runtime/MutableState;", "supportedLanguages", "", "applyLanguage", "", "context", "Landroid/content/Context;", "languageCode", "getCurrentLanguageDisplayName", "getLanguageName", "code", "getSupportedLanguages", "", "Lkotlin/Pair;", "getSystemLanguage", "initialize", "isRightToLeft", "", "setLanguage", "Companion", "app_release"})
public final class LocalizationManager {
    @kotlin.jvm.Volatile()
    @org.jetbrains.annotations.Nullable()
    private static volatile com.skipfeed.android.data.LocalizationManager INSTANCE;
    @org.jetbrains.annotations.NotNull()
    private final androidx.compose.runtime.MutableState currentLanguage$delegate = null;
    @org.jetbrains.annotations.NotNull()
    private final java.util.Map<java.lang.String, java.lang.String> supportedLanguages = null;
    @org.jetbrains.annotations.NotNull()
    public static final com.skipfeed.android.data.LocalizationManager.Companion Companion = null;
    
    private LocalizationManager() {
        super();
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getCurrentLanguage() {
        return null;
    }
    
    private final void setCurrentLanguage(java.lang.String p0) {
    }
    
    public final void initialize(@org.jetbrains.annotations.NotNull()
    android.content.Context context) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.util.List<kotlin.Pair<java.lang.String, java.lang.String>> getSupportedLanguages() {
        return null;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getLanguageName(@org.jetbrains.annotations.NotNull()
    java.lang.String code) {
        return null;
    }
    
    public final void setLanguage(@org.jetbrains.annotations.NotNull()
    android.content.Context context, @org.jetbrains.annotations.NotNull()
    java.lang.String languageCode) {
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getSystemLanguage() {
        return null;
    }
    
    private final void applyLanguage(android.content.Context context, java.lang.String languageCode) {
    }
    
    public final boolean isRightToLeft() {
        return false;
    }
    
    @org.jetbrains.annotations.NotNull()
    public final java.lang.String getCurrentLanguageDisplayName() {
        return null;
    }
    
    @kotlin.Metadata(mv = {1, 9, 0}, k = 1, xi = 48, d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002\u00a2\u0006\u0002\u0010\u0002J\u0006\u0010\u0005\u001a\u00020\u0004R\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u0004X\u0082\u000e\u00a2\u0006\u0002\n\u0000\u00a8\u0006\u0006"}, d2 = {"Lcom/skipfeed/android/data/LocalizationManager$Companion;", "", "()V", "INSTANCE", "Lcom/skipfeed/android/data/LocalizationManager;", "getInstance", "app_release"})
    public static final class Companion {
        
        private Companion() {
            super();
        }
        
        @org.jetbrains.annotations.NotNull()
        public final com.skipfeed.android.data.LocalizationManager getInstance() {
            return null;
        }
    }
}