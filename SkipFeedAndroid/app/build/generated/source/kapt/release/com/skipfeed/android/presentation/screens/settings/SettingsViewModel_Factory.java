package com.skipfeed.android.presentation.screens.settings;

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
public final class SettingsViewModel_Factory implements Factory<SettingsViewModel> {
  private final Provider<UserPreferencesRepository> userPreferencesRepositoryProvider;

  private final Provider<SearchRepository> searchRepositoryProvider;

  private final Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider;

  public SettingsViewModel_Factory(
      Provider<UserPreferencesRepository> userPreferencesRepositoryProvider,
      Provider<SearchRepository> searchRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    this.userPreferencesRepositoryProvider = userPreferencesRepositoryProvider;
    this.searchRepositoryProvider = searchRepositoryProvider;
    this.usageAnalyticsRepositoryProvider = usageAnalyticsRepositoryProvider;
  }

  @Override
  public SettingsViewModel get() {
    return newInstance(userPreferencesRepositoryProvider.get(), searchRepositoryProvider.get(), usageAnalyticsRepositoryProvider.get());
  }

  public static SettingsViewModel_Factory create(
      Provider<UserPreferencesRepository> userPreferencesRepositoryProvider,
      Provider<SearchRepository> searchRepositoryProvider,
      Provider<UsageAnalyticsRepository> usageAnalyticsRepositoryProvider) {
    return new SettingsViewModel_Factory(userPreferencesRepositoryProvider, searchRepositoryProvider, usageAnalyticsRepositoryProvider);
  }

  public static SettingsViewModel newInstance(UserPreferencesRepository userPreferencesRepository,
      SearchRepository searchRepository, UsageAnalyticsRepository usageAnalyticsRepository) {
    return new SettingsViewModel(userPreferencesRepository, searchRepository, usageAnalyticsRepository);
  }
}
