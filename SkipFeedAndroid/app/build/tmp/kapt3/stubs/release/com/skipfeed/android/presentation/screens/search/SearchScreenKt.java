package com.skipfeed.android.presentation.screens.search;

@kotlin.Metadata(mv = {1, 9, 0}, k = 2, xi = 48, d1 = {"\u0000@\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\u001a(\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001aD\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000b2\u0012\u0010\f\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00010\r2\f\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a.\u0010\u000f\u001a\u00020\u00012\u0006\u0010\u0010\u001a\u00020\u00112\u0012\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00010\r2\b\b\u0002\u0010\u0006\u001a\u00020\u0007H\u0003\u001a\u0012\u0010\u0013\u001a\u00020\u00012\b\b\u0002\u0010\u0014\u001a\u00020\u0015H\u0007\u001a\u0010\u0010\u0016\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000bH\u0002\u001a\u0018\u0010\u0017\u001a\u00020\u00032\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\u0018\u001a\u00020\u0019H\u0003\u00a8\u0006\u001a"}, d2 = {"RecentSearchChip", "", "query", "", "onClick", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "SearchInputField", "searchQuery", "platform", "Lcom/skipfeed/android/data/model/Platform;", "onQueryChange", "Lkotlin/Function1;", "onSearch", "SearchModeToggleView", "searchMode", "Lcom/skipfeed/android/data/model/SearchMode;", "onSearchModeChanged", "SearchScreen", "viewModel", "Lcom/skipfeed/android/presentation/screens/search/SearchViewModel;", "getPlaceholderText", "getSearchButtonText", "context", "Landroid/content/Context;", "app_release"})
public final class SearchScreenKt {
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    public static final void SearchScreen(@org.jetbrains.annotations.NotNull()
    com.skipfeed.android.presentation.screens.search.SearchViewModel viewModel) {
    }
    
    @kotlin.OptIn(markerClass = {androidx.compose.material3.ExperimentalMaterial3Api.class})
    @androidx.compose.runtime.Composable()
    private static final void SearchInputField(java.lang.String searchQuery, com.skipfeed.android.data.model.Platform platform, kotlin.jvm.functions.Function1<? super java.lang.String, kotlin.Unit> onQueryChange, kotlin.jvm.functions.Function0<kotlin.Unit> onSearch, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void SearchModeToggleView(com.skipfeed.android.data.model.SearchMode searchMode, kotlin.jvm.functions.Function1<? super com.skipfeed.android.data.model.SearchMode, kotlin.Unit> onSearchModeChanged, androidx.compose.ui.Modifier modifier) {
    }
    
    @androidx.compose.runtime.Composable()
    private static final void RecentSearchChip(java.lang.String query, kotlin.jvm.functions.Function0<kotlin.Unit> onClick, androidx.compose.ui.Modifier modifier) {
    }
    
    private static final java.lang.String getPlaceholderText(com.skipfeed.android.data.model.Platform platform) {
        return null;
    }
    
    @androidx.compose.runtime.Composable()
    private static final java.lang.String getSearchButtonText(com.skipfeed.android.data.model.Platform platform, android.content.Context context) {
        return null;
    }
}