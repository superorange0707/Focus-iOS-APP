package com.skipfeed.android.presentation.screens.history;

import com.skipfeed.android.data.repository.SearchRepository;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata
@QualifierMetadata
@DaggerGenerated
@Generated(
    value = "dagger.internal.codegen.ComponentProcessor",
    comments = "https://dagger.dev"
)
@SuppressWarnings({
    "unchecked",
    "rawtypes",
    "KotlinInternal",
    "KotlinInternalInJava"
})
public final class SearchHistoryViewModel_Factory implements Factory<SearchHistoryViewModel> {
  private final Provider<SearchRepository> searchRepositoryProvider;

  public SearchHistoryViewModel_Factory(Provider<SearchRepository> searchRepositoryProvider) {
    this.searchRepositoryProvider = searchRepositoryProvider;
  }

  @Override
  public SearchHistoryViewModel get() {
    return newInstance(searchRepositoryProvider.get());
  }

  public static SearchHistoryViewModel_Factory create(
      Provider<SearchRepository> searchRepositoryProvider) {
    return new SearchHistoryViewModel_Factory(searchRepositoryProvider);
  }

  public static SearchHistoryViewModel newInstance(SearchRepository searchRepository) {
    return new SearchHistoryViewModel(searchRepository);
  }
}
