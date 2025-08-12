package com.skipfeed.android.presentation.screens.search;

import com.skipfeed.android.data.repository.SearchRepository;
import com.skipfeed.android.data.repository.UsageAnalyticsRepository;
import com.skipfeed.android.data.repository.UserPreferencesRepository;
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
public final class SearchViewModel_Factory implements Factory<SearchViewModel> {
  private final Provider<SearchRepository> searchRepositoryProvider;

  private final Provider<UserPreferencesRepository> userPreferencesRepositoryProvider;

  private final Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider;

  public SearchViewModel_Factory(Provider<SearchRepository> searchRepositoryProvider,
      Provider<UserPreferencesRepository> userPreferencesRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    this.searchRepositoryProvider = searchRepositoryProvider;
    this.userPreferencesRepositoryProvider = userPreferencesRepositoryProvider;
    this.usageAnalyticsRepositoryProvider = usageAnalyticsRepositoryProvider;
  }

  @Override
  public SearchViewModel get() {
    return newInstance(searchRepositoryProvider.get(), userPreferencesRepositoryProvider.get(), usageAnalyticsRepositoryProvider.get());
  }

  public static SearchViewModel_Factory create(Provider<SearchRepository> searchRepositoryProvider,
      Provider<UserPreferencesRepository> userPreferencesRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    return new SearchViewModel_Factory(searchRepositoryProvider, userPreferencesRepositoryProvider, usageAnalyticsRepositoryProvider);
  }

  public static SearchViewModel newInstance(SearchRepository searchRepository,
      UserPreferencesRepository userPreferencesRepository,
      UsageAnalyticsRepository usageAnalyticsRepository) {
    return new SearchViewModel(searchRepository, userPreferencesRepository, usageAnalyticsRepository);
  }
}
